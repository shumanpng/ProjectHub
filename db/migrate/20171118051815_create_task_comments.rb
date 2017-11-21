class CreateTaskComments < ActiveRecord::Migration
  def change
    create_table :task_comments do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :task_id
      t.boolean :grp_admin
      t.text :task_comment

      t.timestamps null: false
    end
  end
end
