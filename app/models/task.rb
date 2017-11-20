class Task < ActiveRecord::Base
  acts_as_votable
  # belongs_to :group
  belongs_to :user
  # validates_length_of :title, :minimum => 1
  validates :title, :presence => true
  validates :created_by, :presence => true
  validates :state, :presence => true

end
