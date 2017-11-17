class RenameDueDateToDeadline < ActiveRecord::Migration
  def change
    rename_column :tasks, :due_date, :deadline
  end
end
