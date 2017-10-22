json.extract! user, :id, :name, :is_admin, :password, :email, :date_created, :created_at, :updated_at
json.url user_url(user, format: :json)
