# frozen_string_literal: true

json.extract! announcement, :id, :announcement_id, :title, :description, :posted_on, :user_id, :created_at, :updated_at
json.url announcement_url(announcement, format: :json)
