# frozen_string_literal: true

# DashboardsController
class DashboardsController < ApplicationController
  def show
    @perms = grab_permissions
    @is_admin = @perms[:is_admin]
    @create_modify_events = @perms[:create_modify_events]
    @create_modify_announcements = @perms[:create_modify_announcements]
    @user = grab_user

    # get announcements/events that user is planning to attend and are >= current date
    @planned_attendances = Attendance.where(user_id: @user.id, plans_to_attend: true)
    
    @recent_announcements_all = Announcement.where({ event_id: nil }, posted_on: 0.day.ago..)
    @recent_announcements_specific = []
    @events = []
    
    @planned_attendances.each do |attendance|
      @e = Event.where(id: attendance.event_id, date: 0.day.ago..)

      if !@e.empty?
        @events.append(@e.first)
        @a = Announcement.where(event_id: @e.first.id)
        @recent_announcements_specific.append(@a.first)  if !@a.empty?
      end
    end
    
    @announcements = @recent_announcements_all + @recent_announcements_specific
  end
end
