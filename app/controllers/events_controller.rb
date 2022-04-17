# frozen_string_literal: true

# EventsController
class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def toggle
    @user = grab_user
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @user.nil?

    @event_id = params[:id]
    @attendance = Attendance.where(event_id: @event_id, user_id: @user.id).first
    if @attendance.nil?
      @attendance = Attendance.new(event_id: @event_id, user_id: @user.id, attend_time_start: nil, attend_time_end: nil, plans_to_attend: true)
      @attendance.save validate: false
      @attendance.errors.full_messages if @attendance.errors.any?
    else
      @attendance.update(plans_to_attend: !@attendance.plans_to_attend)
    end
    redirect_to '/events'
  end

  # GET /events or /events.json
  def index
    @events = Event.all
    @attendings = []
    @perms = grab_permissions
    return redirect_to '/', notice: 'Invalid user session. Please try logging in again.' if @perms.nil?

    @events.each do |event|
      @attending = Attendance.where(event_id: event.id, user_id: @user.id).first
      if @attending.nil?
        @attendings.append(false)
      else
        @attendings.append(@attending.plans_to_attend)
      end
    end

    @events_attendings = @events.zip(@attendings)
  end

  # GET /events/1 or /events/1.json
  def show
    @perms = grab_permissions
    
    @plans_to_attend = []
    @username_list = []
    
    if @perms[:create_modify_events]
      @valid_plans_to_attend = Attendance.where(plans_to_attend: true)
      
      @valid_plans_to_attend.each do |vpta|
        @plans_to_attend.append(Attendance.where(event_id: vpta.event_id).first)
      end

      @plans_to_attend.each do |user_param|
        @username_list.append(User.where(id: user_param.user_id).last)
      end
    end
  end

  # GET /events/new
  def new
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_events]

    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_events]
  end

  # POST /events or /events.json
  def create
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_events]

    @event = Event.new(event_params)
    if !@event.event_time_start.nil? && !@event.event_time_end.nil? && (@event.event_time_start > @event.event_time_end)
      flash[:alert] = 'Event must start before it ends'
      return render 'new'
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render :index, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_events]

    if event_params[:event_time_start] > event_params[:event_time_end]
      flash[:alert] = 'Event must start before it ends'
      return render 'edit'
    end

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.json { render :index, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    return redirect_to '/', notice: 'Insufficient permissions.' unless grab_permissions[:create_modify_events]

    @related_announcements = Announcement.where(event_id: @event.id)
    @related_attendances = Attendance.where(event_id: @event.id)

    @related_announcements&.each do |a|
      a.destroy
    end

    @related_attendances&.each do |a|
      a.destroy
    end

    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:user_id, :title, :description, :date, :event_time_start, :event_time_end)
  end
end
