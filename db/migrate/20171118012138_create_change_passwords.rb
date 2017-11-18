class CreateChangePasswords < ActiveRecord::Migration
  def change
    create_table :change_passwords do |t|
      t.string :current_password
      t.string :new_password
      t.string :confirm_password

      t.timestamps null: false
    end
  end
end
