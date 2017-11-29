class Task < ActiveRecord::Base
  has_one :point
  # acts_as_votable
  # belongs_to :group
  belongs_to :user
  has_many :task_comments
  # validates_length_of :title, :minimum => 1
  validates :title, :presence => true
  validates :created_by, :presence => true
  validates :state, :presence => true

  # takes a task object as input and returns number of comments it has
  def comment_count(task)
    return TaskComment.where(:task_id => task.id).count
  end
end
