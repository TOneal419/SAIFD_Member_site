json.extract! attendance, :id, :event_id, :user_id, :attendance_id, :created_at, :updated_at
json.url attendance_url(attendance, format: :json)
