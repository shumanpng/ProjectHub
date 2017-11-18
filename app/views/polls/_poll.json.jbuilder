json.extract! poll, :id, :points, :created_at, :updated_at
json.url poll_url(poll, format: :json)
