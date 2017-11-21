class AddAdminToTaskComments < ActiveRecord::Migration
  def change
    add_column :task_comments, :isadmin, :boolean
  end
end
