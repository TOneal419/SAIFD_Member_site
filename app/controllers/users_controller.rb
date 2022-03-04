# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # allows /users#new (which has been routed to /auth/sign_up) to not require authentication
  skip_before_action :authenticate_admin!, only: %i[new create show]

  # GET /users or /users.json
  def index
    # get permissions
    @id_token = cookies[:current_user_session]
    @email = Admin.where(uid: @id_token).first.email
    @user = User.where(email: @email)
    @see_all_users = Permission.where(user_id: @user.first.id).first.is_admin

    # default to only seeing self
    @users = @user

    if @see_all_users
      @users = User.all
    end
  end

  # GET /users/1 or /users/1.json
  def show
    redirect_to '/', notice: "Attempted to access disabled route."
  end

  # GET /users/new
  def new
    @session = session[:new_user_session]
    @user = User.new(email: @session["email"], first_name: @session["full_name"].split[0], last_name: @session["full_name"].split[1])
  end

  # GET /users/1/edit
  def edit
    # ensure correct privilleges
    @id_token = cookies[:current_user_session]
    @email = Admin.where(uid: @id_token).first.email
    @user = User.where(email: @email).first
    @can_edit = Permission.where(user_id: @user.id).first.is_admin

    if !@can_edit
      redirect_to '/users#index', notice: 'Insufficient privilleges'
    end

    # grab params from URL
    @user = User.find_by(email: params[:email])
  end

  # POST /users or /users.json
  def create
    session[:new_user_session] = nil

    @user = User.new(user_params)
    @user.build_permission if @user.permission == nil
    @user.permission = Permission.new(is_admin: true, create_modify_events: true, create_modify_announcements: true, view_all_attendances: true)
    @user.permission.save
    @user.update(permission_id: @user.permission.id)
    @user.update(report_rate: 'Disabled') # by default, normal users shouldn't have reports

    respond_to do |format|
      if @user.save
        @user.permission.update(user_id: @user.id)
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
    @user = User.find_by(email: user_params["email"])
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
    @user = User.find_by(email: params["email"])
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
    params.require(:user).permit(:email, :first_name, :last_name, :class_year, :report_rate, :permission_id, permission_attributes: [:is_admin, :create_modify_events, :create_modify_announcements, :view_all_attendances])
  end
end
