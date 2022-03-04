# frozen_string_literal: true

# DashboardsController
class DashboardsController < ApplicationController
  def show
    @perms = get_permissions
    @is_admin = @perms[:is_admin]
    @create_modify_events = @perms[:create_modify_events]
    @create_modify_announcements = @perms[:create_modify_announcements]
    @user = get_user
  end
end
