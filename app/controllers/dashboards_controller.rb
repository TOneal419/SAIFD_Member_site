# frozen_string_literal: true

# DashboardsController
class DashboardsController < ApplicationController
  def download
    return redirect_to '/', notice: 'Insufficient Permissions' unless grab_permissions[:is_admin]

    @users = User.all
    @events = Event.all
    @attendances = Attendance.all
    @announcements = Announcement.all

    respond_to do |format|
      format.xlsx do
        render xlsx: 'data', filename: 'report.xlsx'
      end
    end
  end

  def help
    render 'help'
  end

  def show
    @perms = grab_permissions
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @perms.nil?

    @is_admin = @perms[:is_admin]
    @create_modify_events = @perms[:create_modify_events]
    @create_modify_announcements = @perms[:create_modify_announcements]
    @user = grab_user
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @user.nil?

    # get announcements/events that user is planning to attend and are >= current date
    @planned_attendances = Attendance.where(user_id: @user.id, plans_to_attend: true)

    @recent_announcements_all = Announcement.where({ event_id: nil }, posted_on: 10.days.ago..)
    @recent_announcements_specific = []
    @events = []

    @planned_attendances.each do |attendance|
      @e = Event.where(id: attendance.event_id, date: 0.days.ago..)

      next if @e.empty?

      @events.append(@e.first)
      @a = Announcement.where(event_id: @e.first.id)
      @recent_announcements_specific.append(@a.first) unless @a.empty?
    end

    @announcements = @recent_announcements_all + @recent_announcements_specific
  end
end
