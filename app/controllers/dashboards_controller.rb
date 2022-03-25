# frozen_string_literal: true

# DashboardsController
class DashboardsController < ApplicationController
  def show
    @perms = grab_permissions
    @is_admin = @perms[:is_admin]
    @create_modify_events = @perms[:create_modify_events]
    @create_modify_announcements = @perms[:create_modify_announcements]
    @user = grab_user

    # TODO: list out events and announcements
    # @current_time = DateTime.now()
    # @active_events = Event.where(event_time_start: , event_time_end: )
    # @recent_announcements = Announcement.where()
  end
end
