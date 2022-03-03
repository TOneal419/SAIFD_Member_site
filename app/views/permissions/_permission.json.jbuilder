json.extract! permission, :id, :title, :is_admin, :create_modify_events, :create_modify_announcements, :view_all_attendances, :created_at, :updated_at
json.url permission_url(permission, format: :json)
