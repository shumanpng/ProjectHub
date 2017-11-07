class User < ActiveRecord::Base
    has_many :ActiveUsers
    has_many :tasks
    has_many :group_memberships
    has_many :groups, :through => :group_memberships
    has_many :group_requests

    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
    validates :name, :presence => true, :length => { :maximum => 50 }
    validates :email, :presence => true, :format => { :with => EMAIL_REGEX }, :uniqueness => true
end
