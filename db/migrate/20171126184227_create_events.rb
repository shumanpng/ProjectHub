class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.string :location_name
      t.string :location_address
      t.string :location_city
      t.string :location_country
      t.string :location_postal_code

      t.timestamps null: false
    end
  end
end
