class Group < ActiveRecord::Base
  has_many :tasks

  # note: ':dependent => :destroy' deletes all of a group's child objects
  # (here, group memberships and group requests) when the group is destroyed
  has_many :group_memberships, :dependent => :destroy
  has_many :users, :through => :group_memberships
  has_many :group_requests, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true


  # Decides the type of access a user has to a group (based on account type and
  # on the status of their group request).
  def typeOfAccess(group, curr_user)
    if User.where(:id => curr_user.id, :is_admin => true).exists?
      # user is an admin; they have access to all groups
      'view'
    else
      if GroupMembership.where(:user_id => curr_user.id, :group_id => group.id).exists?
        # user is already a member of group
        'view'
      elsif GroupRequest.where(:user_id => curr_user.id, :group_id => group.id, :status => 'denied').exists?
        # user's request was denied
        'denied'
      elsif GroupRequest.where(:user_id => curr_user.id, :group_id => group.id, :status => 'pending').exists?
        # user has sent a request
        'pending'
      else
        # user has not sent a request
        'join'
      end
    end
  end

  # Takes group object and user object as inputs, and
  # returns the status of the user relative to the group.
  # Pre-conditions: user is a member of the group and does not have an admin account.
  def get_user_status(group, user)
    if GroupMembership.where(:user_id => user.id, :group_id => group.id, :is_admin => false).exists?
      # case a.: user is not the group admin
      'not admin'
    elsif GroupMembership.where(:group_id => group.id, :is_admin => false).count == 1
      # case b.: user is the group admin and there is one other member
      'one left'
    elsif GroupMembership.where(:group_id => group.id, :is_admin => false).count > 1
      # case c.: user is the group admin and there are multiple other members
      'many left'
    else
      # case d.: user is the group admin but there are no other members
      'none left'
    end
  end

  # Takes a group object as input and returns an array of all users who are
  # members of the group, but not group admin (as user objects).
  def get_non_admin_members(group)
    # iterate through all the group's memberships and append all non-admins to array
    @non_admins = []
    group.group_memberships.each do |member|
      if member.is_admin == false
        @user = User.find(member.user_id)
        @non_admins << @user
      end
    end
    return @non_admins
  end

  # takes a group as input and returns the id of its admin
  def get_admin(group)
    @admin_membership = GroupMembership.where(:group_id => group.id, :is_admin => true).take
    return @admin_membership.user_id
  end
end
