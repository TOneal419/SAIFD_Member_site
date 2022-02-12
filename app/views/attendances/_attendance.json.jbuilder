# frozen_string_literal: true

json.extract! attendance, :id, :event_id, :user_id, :attend_time_start, :attend_time_end, :created_at, :updated_at
json.url attendance_url(attendance, format: :json)
