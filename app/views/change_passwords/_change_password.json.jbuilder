json.extract! change_password, :id, :current_password, :new_password, :confirm_password, :created_at, :updated_at
json.url change_password_url(change_password, format: :json)
