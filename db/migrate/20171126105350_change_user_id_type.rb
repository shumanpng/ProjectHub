class ChangeUserIdType < ActiveRecord::Migration
  def up
    remove_column :points, :user_id
    add_column :points, :user_email, :string
  end

  def down
    remove_column :points, :user_email
  end
end
