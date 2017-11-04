class AddGroupIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :group_id, :integer
  end
end
