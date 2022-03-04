# frozen_string_literal: true

# AnnouncementsController
class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: %i[show edit update destroy]

  # GET /announcements or /announcements.json
  def index
    @announcements = Announcement.all
    @perms = get_permissions
  end

  # GET /announcements/1 or /announcements/1.json
  def show
    redirect_to '/', notice: "Attempted to access disabled route."
  end

  # GET /announcements/new
  def new
    if !get_permissions[:create_modify_announcements]
      redirect_to '/', notice: "Insufficient permissions."
    end

    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
    if !get_permissions[:create_modify_announcements]
      redirect_to '/', notice: "Insufficient permissions."
    end
  end

  # POST /announcements or /announcements.json
  def create
    if !get_permissions[:create_modify_announcements]
      redirect_to '/', notice: "Insufficient permissions."
    end

    @announcement = Announcement.new(announcement_params)
    @announcement.update(posted_on: DateTime.now)
    @user = get_user

    @announcement.update(user_id: @user.id)

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to announcements_path, notice: 'Announcement was successfully created.' }
        format.json { render :index, status: :created, location: @announcement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1 or /announcements/1.json
  def update
    if !get_permissions[:create_modify_announcements]
      redirect_to '/', notice: "Insufficient permissions."
    end

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
    if !get_permissions[:create_modify_announcements]
      redirect_to '/', notice: "Insufficient permissions."
    end

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
