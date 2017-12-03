class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :message
      t.integer :user_id
      t.integer :group_id
      t.boolean :status

      t.timestamps null: false
    end
  end
end
