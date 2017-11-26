json.extract! event, :id, :name, :description, :date, :location_name, :location_address, :location_city, :location_country, :location_postal_code, :created_at, :updated_at
json.url event_url(event, format: :json)
