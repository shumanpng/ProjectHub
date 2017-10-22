json.extract! active_user, :id, :user_id, :token, :created_at, :updated_at
json.url active_user_url(active_user, format: :json)
