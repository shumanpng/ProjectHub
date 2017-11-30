class TaskComment < ActiveRecord::Base
	belongs_to :user
	belongs_to :task

	validates :task_comment, :presence => true
	validates :task_id, :presence => true
	validates :user_id, :presence => true
end
