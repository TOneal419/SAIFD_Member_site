json.extract! timeslot, :id, :timeslot_id, :attendance_id, :attend_time_start, :attend_time_end, :event_time_start, :event_time_end, :created_at, :updated_at
json.url timeslot_url(timeslot, format: :json)
