class CreateGroupRequests < ActiveRecord::Migration
  def change
    create_table :group_requests do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :status

      t.timestamps null: false
    end
  end
end
