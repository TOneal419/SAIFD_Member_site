# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # allows /users#new (which has been routed to /auth/sign_up) to not require authentication
  skip_before_action :authenticate_admin!, only: %i[new create show]

  # GET /users or /users.json
  def index
    # get permissions
    @user = grab_user
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @user.nil?

    # default to only seeing self
    @users = User.where(id: @user.id)

    @users = User.all if grab_permissions[:is_admin]
  end

  # GET /users/1 or /users/1.json
  def show
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # GET /users/new
  def new
    @session = session[:new_user_session]
    @user = User.new(email: @session['email'], first_name: @session['full_name'].split[0], last_name: @session['full_name'].split[1])
  end

  # GET /users/1/edit
  def edit
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:is_admin]
    return redirect_to '/', notice: 'Cannot edit WebMaster.' if params[:email].casecmp('wjmckinley@tamu.edu').zero?

    # grab params from URL
    @user = User.find_by(email: params[:email])
  end

  # POST /users or /users.json
  def create
    session[:new_user_session] = nil

    @user = User.new(user_params)
    @user.build_permission if @user.permission.nil?
    @user.permission = Permission.new(is_admin: false, create_modify_events: false, create_modify_announcements: false, view_all_attendances: false)
    @user.permission.update(is_admin: true, create_modify_events: true, create_modify_announcements: true, view_all_attendances: true) if @user.email.casecmp(ENV['webmaster1']).zero? || @user.email.casecmp(ENV['webmaster2']).zero?
    @user.permission.save
    @user.update(permission_id: @user.permission.id)
    @user.update(report_rate: 'Disabled') # by default, normal users shouldn't have reports

    respond_to do |format|
      if @user.save
        @user.permission.update(user_id: @user.id)
        UsermailerMailer.welcome_email(@user).deliver_later
        format.html do
          redirect_to new_admin_session_path, notice: 'User was successfully created. Please log in again to confirm.'
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:is_admin]

    @user = User.find_by(email: user_params['email'])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:is_admin]
    return redirect_to '/', notice: 'Cannot destroy WebMaster.' if params[:email].casecmp('wjmckinley@tamu.edu').zero? || params[:email].casecmp('bill.mckinley@ag.tamu.edu').zero?

    @current_user = grab_user
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @user.nil?
    return redirect_to '/', notice: 'Cannot destroy self.' if @current_user.email.casecmp(params[:email]).zero?

    @user = User.find_by(email: params['email'])

    @related_attendances = Attendance.where(user_id: @user.id)
    @related_attendances&.each do |attendance|
      attendance.destroy
    end

    @permission = Permission.where(user_id: @user.id).first
    @permission.destroy

    @admin = Admin.where(email: @user.email).first
    @admin.destroy

    @related_announcements = Announcement.where(user_id: @user.id)
    @related_announcements&.each do |announcement|
      announcement.destroy
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(email: params[:email])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :class_year, :report_rate, :permission_id,
                                 permission_attributes: %i[is_admin create_modify_events create_modify_announcements view_all_attendances])
  end
end
