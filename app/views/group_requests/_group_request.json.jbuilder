json.extract! group_request, :id, :user_id, :group_id, :status, :created_at, :updated_at
json.url group_request_url(group_request, format: :json)
