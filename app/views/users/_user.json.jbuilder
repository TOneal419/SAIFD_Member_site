# frozen_string_literal: true

json.extract! user, :id, :email, :first_name, :last_name, :class_year, :report_rate, :permission_id, :created_at,
              :updated_at
json.url user_url(user, format: :json)
