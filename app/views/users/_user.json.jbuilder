json.extract! user, :id, :email, :first_name, :last_name, :class_year, :role_id, :report_rate, :user_id, :created_at, :updated_at
json.url user_url(user, format: :json)
