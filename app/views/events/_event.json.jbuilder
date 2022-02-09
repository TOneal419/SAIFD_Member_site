json.extract! event, :id, :event_id, :title, :description, :date, :created_at, :updated_at
json.url event_url(event, format: :json)
