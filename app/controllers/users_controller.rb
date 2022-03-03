# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # allows /users#new (which has been routed to /auth/sign_up) to not require authentication
  skip_before_action :authenticate_admin!, only: %i[new create show]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @session = session[:new_user_session]
    @user = User.new(email: @session["email"], first_name: @session["full_name"].split[0], last_name: @session["full_name"].split[1])
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    session[:new_user_session] = nil

    @user = User.new(user_params)
    @user_permission = Permission.new(is_admin: false, create_modify_events: false, create_modify_announcements: false, view_all_attendances: false)
    @user_permission.save
    @user.update(permission_id: @user_permission.id)
    @user.update(report_rate: 'Disabled') # by default, normal users shouldn't have reports

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to user_url(@user), notice: 'User was successfully created. Please log in again to confirm.'
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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :class_year, :report_rate, :permission_id)
  end
end
