json.extract! event, :id, :event_id, :title, :description, :date, :event_time_start, :event_time_end, :created_at, :updated_at
json.url event_url(event, format: :json)
