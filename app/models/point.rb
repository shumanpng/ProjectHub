class Point < ActiveRecord::Base
  acts_as_votable
  belongs_to :task
end
