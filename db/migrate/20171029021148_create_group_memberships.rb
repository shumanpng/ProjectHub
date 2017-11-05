class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :is_admin

      t.timestamps null: false
    end
  end
end
