class CreateUserLogins < ActiveRecord::Migration
  def change
    create_table :user_logins do |t|
      t.string :email
      t.string :password
      t.string :token

      t.timestamps null: false
    end
  end
end
