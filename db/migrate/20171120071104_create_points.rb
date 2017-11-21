class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :level
      t.integer :user_id
      t.integer :task_id

      t.timestamps null: false
    end
  end
end
