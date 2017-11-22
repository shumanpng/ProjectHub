class UserValidation < ActiveModel::Validator
    def validate(record)
        if record.check_password
            if record.password =~ /\d/         # Calling String's =~ method.
                # valid contains number
            else
                record.errors[:base] << "Your password must contain at least 1 number."
            end

            if record.password =~ /[A-Z]/
                # valid contains upper case
            else
                record.errors[:base] << "Your password must contain at least 1 capital."
            end

            if record.password.length <= 5
                record.errors[:base] << "Your password is not long enough."
            end
        end
    end
end

class User < ActiveRecord::Base
  acts_as_voter

  validates_with UserValidation
  attr_accessor :check_password

  has_many :ActiveUsers
  has_many :tasks
  has_many :group_memberships
  has_many :groups, :through => :group_memberships
  has_many :group_requests
  has_many :task_comments

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :format => { :with => EMAIL_REGEX }, :uniqueness => true


  # takes a user object as input and returns user's network (all the users with whom
  # they share a common group, as an array of user objects)
  def get_network(curr_user)
    @network = []
    curr_user.groups.each do |group|
      group.users.each do |user|
        if user.id != curr_user.id
          unless @network.include?(user)
            @network << user
          end
        end
      end
    end
    return @network
  end

end
