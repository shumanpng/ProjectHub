class AddColumnsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :description, :text
    add_column :companies, :logo, :string
    add_column :companies, :city, :string
    add_column :companies, :country, :string
  end
end
