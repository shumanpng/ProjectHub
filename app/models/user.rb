class User < ActiveRecord::Base
    has_many :ActiveUsers
    has_many :tasks
    has_many :group_memberships
    has_many :groups, :through => :group_memberships
    has_many :group_requests
end
