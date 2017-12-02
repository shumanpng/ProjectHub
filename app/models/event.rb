class Event < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true
  validates :location_address, :presence => true
  validates :location_city, :presence => true
end
