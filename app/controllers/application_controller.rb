# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  # make sure user is authenticated EXCEPT when creating a new user (/user#new/ which has been routed to /auth/sign_up)
  before_action :authenticate_admin!, except: [:users] 

  def get_permissions
    @id_token = cookies[:current_user_session]

    # if no current session, then no permissions
    @is_admin = false
    @create_modify_events = false
    @create_modify_announcements = false
    @view_all_attendances = false

    unless @id_token.nil?
      @email = Admin.where(uid: @id_token).first.email
      @user = User.where(email: @email).first
      @perms = Permission.where(user_id: @user.id).first

      @is_admin = @perms.is_admin
      @create_modify_events = @perms.create_modify_events
      @create_modify_announcements = @perms.create_modify_announcements
      @view_all_attendances = @perms.view_all_attendances
    end
    
    @ret = {"is_admin": @is_admin, "create_modify_events": @create_modify_events, "create_modify_announcements": @create_modify_announcements, "view_all_attendances": @view_all_attendances}
  end
end
