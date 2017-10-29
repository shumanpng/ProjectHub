class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :created_by
      t.datetime :due_date
      t.integer :points
      t.string :group
      t.string :state
      t.string :type

      t.timestamps null: false
    end
  end
end
