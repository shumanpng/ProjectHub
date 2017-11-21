class AddNameToTaskComments < ActiveRecord::Migration
  def change
    add_column :task_comments, :user_name, :string
  end
end
