class Group < ActiveRecord::Base
  has_many :group_memberships
  has_many :users, :through => :group_memberships
end
