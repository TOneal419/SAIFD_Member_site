# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  # make sure user is authenticated EXCEPT when creating a new user (/user#new/ which has been routed to /auth/sign_up)
  # rubocop:disable all
  before_action :authenticate_admin!, except: [:users]
  # rubocop: enable all

  # gets info of user currently logged in
  def grab_user
    @id_token = cookies[:current_user_session]
    @google_acc = Admin.where(uid: @id_token)
    if @id_token.nil? || @google_acc.nil?
      cookies[:current_user_session] = nil
      return redirect_to '/', notice: 'Invalid user session. Please try logging in again.'
    else
      @email = @google_acc.first.email
      @user = User.where(email: @email).first
    end
  end

  def grab_permissions
    # if no current session, then no permissions
    @is_admin = false
    @create_modify_events = false
    @create_modify_announcements = false
    @view_all_attendances = false

    @user = grab_user
    unless cookies[:current_user_session].nil?
      @perms = Permission.where(user_id: @user.id).first

      @is_admin = @perms.is_admin
      @create_modify_events = @perms.create_modify_events
      @create_modify_announcements = @perms.create_modify_announcements
      @view_all_attendances = @perms.view_all_attendances
    end

    @ret = { "is_admin": @is_admin, "create_modify_events": @create_modify_events, "create_modify_announcements": @create_modify_announcements,
             "view_all_attendances": @view_all_attendances }
  end

  # TODO: not in use... requires credit card info for Heroku Scheduler
  # TODO: also, edit send_report.html.erb
  # TODO: if ever want to use, schedule "send_reports" to run automatically via Heroku Scheduler
  def send_reports
    @users = User.all
    @users.each do |user|
      if user.report_rate != 'Disabled'
        current_date = Date.today
        # weekly implies a report every monday
        # monthly implies a report on the 1st of every month
        if ((user.report_rate == 'Weekly' && current_date.monday?) || (user.report_rate == 'Monthly' && current_date == current_date.end_of_month))
          send_report(user, user.report_rate)
        end
      end
    end
  end
end
