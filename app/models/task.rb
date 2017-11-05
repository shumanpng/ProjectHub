class Task < ActiveRecord::Base
  belongs_to :groups
  has_many :users
  validates_length_of :title, :minimum => 1
end
