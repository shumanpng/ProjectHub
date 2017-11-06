json.extract! group_membership, :id, :user_id, :group_id, :is_admin, :created_at, :updated_at
json.url group_membership_url(group_membership, format: :json)
