class GroupMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :users
end
