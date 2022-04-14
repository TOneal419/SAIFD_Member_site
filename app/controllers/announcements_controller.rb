# frozen_string_literal: true

# AnnouncementsController
class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: %i[show edit update destroy]

  # GET /announcements or /announcements.json
  def index
    @perms = grab_permissions
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @perms.nil?

    @announcements = Announcement.all
    unless @perms[:create_modify_announcements]
      @announcements = []
      @user = grab_user
      return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @user.nil?

      @valid_plans_to_attend = Attendance.where(user_id: @user.id, plans_to_attend: 1)
      @valid_plans_to_attend.each do |vpta|
        @a = Announcement.where(event_id: vpta.event_id).first
        @announcements.append(@a) unless @a.nil?
      end
      @add_ons = Announcement.where(event_id: nil)
      @announcements.concat(@add_ons)
    end
  end

  # GET /announcements/1 or /announcements/1.json
  def show; end

  # GET /announcements/new
  def new
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_announcements]

    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_announcements]
  end

  # POST /announcements or /announcements.json
  def create
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_announcements]

    @announcement = Announcement.new(announcement_params)

    @posted_on = (DateTime.now.to_time - 5.hours).to_datetime
    @announcement.update(posted_on: @posted_on)
    @user = grab_user
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @user.nil?

    @announcement.update(user_id: @user.id)

    respond_to do |format|
      if @announcement.save
        @users = User.all
        unless announcement_params[:event_id].empty?
          @attendances = Attendance.where(event_id: announcement_params[:event_id], plans_to_attend: true)
          @users = []
          @attendances.each do |attendance|
            @users.append(User.where(id: attendance.user_id).first)
          end
        end

        @users.each do |user|
          UsermailerMailer.announce_all(user, @announcement).deliver_later
        end

        format.html { redirect_to announcements_path, notice: 'Announcement was successfully created, and emails have been sent.' }
        format.json { render :index, status: :created, location: @announcement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_announcements]

    @posted_on = (DateTime.now.to_time - 5.hours).to_datetime
    @announcement.update(posted_on: @posted_on)

    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcements_path, notice: 'Announcement was successfully updated.' }
        format.json { render :index, status: :ok, location: @announcement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1 or /announcements/1.json
  def destroy
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_announcements]

    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to announcements_url, notice: 'Announcement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def announcement_params
    params.require(:announcement).permit(:title, :description, :posted_on, :user_id, :event_id)
  end
end
