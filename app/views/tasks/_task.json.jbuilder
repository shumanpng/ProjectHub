json.extract! task, :id, :title, :description, :created_by, :due_date, :points, :group, :state, :type, :created_at, :updated_at
json.url task_url(task, format: :json)
