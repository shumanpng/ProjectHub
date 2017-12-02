class GroupRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :user_id, :presence => true
  validates :group_id, :presence => true
  validates :status, :presence => true, :inclusion => { :in => ['pending', 'denied', 'accepted'] }
end
