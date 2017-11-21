json.extract! task_comment, :id, :user_id, :group_id, :task_id, :grp_admin, :task_comment, :created_at, :updated_at
json.url task_comment_url(task_comment, format: :json)
