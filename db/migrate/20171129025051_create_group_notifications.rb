class CreateGroupNotifications < ActiveRecord::Migration
  def change
    create_table :group_notifications do |t|
      t.text :message
      t.integer :group_id
      t.boolean :status

      t.timestamps null: false
    end
  end
end
