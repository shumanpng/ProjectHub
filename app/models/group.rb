class Group < ActiveRecord::Base
  has_many :group_memberships
  has_many :users, :through => :group_memberships
  has_many :group_requests

  # Decides the type of access a user has to a group (based on account type and
  # on the status of their group request).
  def typeOfAccess(group, token)
    # use the user login instance and match emails to find current user
    @user_login = UserLogin.where(:token => token).take
    @curr_user = User.where(:email => @user_login.email).take

    if User.where(:id => @curr_user.id, :is_admin => true).exists?
      # user is an admin; they have access to all groups
      'view'
    else
      if GroupMembership.where(:user_id => @curr_user.id, :group_id => group.id).exists?
        # user is already a member of group
        'view'
      elsif GroupRequest.where(:user_id => @curr_user.id, :group_id => group.id).empty?
        # user has not sent a request
        'join'
      elsif GroupRequest.where(:user_id => @curr_user.id, :group_id => group.id, :status => 'pending').exists?
        # user has sent a request
        'pending'
      else
        # user's request was denied
        'denied'
      end
    end
  end

end
