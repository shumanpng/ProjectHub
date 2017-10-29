class Task < ActiveRecord::Base
  belongs_to :groups
  has_many :users
end
