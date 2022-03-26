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
      return redirect_to '/', notice: 'Invalid user session.'
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

    unless cookies[:current_user_session].nil?
      @user = grab_user
      @perms = Permission.where(user_id: @user.id).first

      @is_admin = @perms.is_admin
      @create_modify_events = @perms.create_modify_events
      @create_modify_announcements = @perms.create_modify_announcements
      @view_all_attendances = @perms.view_all_attendances
    end

    @ret = { "is_admin": @is_admin, "create_modify_events": @create_modify_events, "create_modify_announcements": @create_modify_announcements,
             "view_all_attendances": @view_all_attendances }
  end
end
