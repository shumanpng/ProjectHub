class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.integer :points

      t.timestamps null: false
    end
  end
end
