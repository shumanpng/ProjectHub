class AddLocationProvinceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location_province, :string
  end
end
