class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :is_admin
      t.string :password
      t.string :email
      t.datetime :date_created

      t.timestamps null: false
    end
  end
end
