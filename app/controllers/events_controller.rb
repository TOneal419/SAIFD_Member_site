# frozen_string_literal: true

# EventsController
class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
    @perms = get_permissions
  end

  # GET /events/1 or /events/1.json
  def show
    redirect_to '/', notice: "Attempted to access disabled route."
  end

  # GET /events/new
  def new
    if !get_permissions[:create_modify_events]
      redirect_to '/', notice: "Insufficient permissions."
    end
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    if !get_permissions[:create_modify_events]
      redirect_to '/', notice: "Insufficient permissions."
    end
    
    if event_params["event_time_start"] > event_params["event_time_end"]
      redirect_to '/events/new', notice: "Event must begin before it ends"
    end
  end

  # POST /events or /events.json
  def create
    @redirected = false

    if !get_permissions[:create_modify_events]
      @redirected = true
      redirect_to '/', notice: "Insufficient permissions."
    end

    if event_params["event_time_start"] > event_params["event_time_end"]
      @redirected = true
      redirect_to '/events/new', notice: "Event must begin before it ends"
    end

    if !@redirected
      @event = Event.new(event_params)

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
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    if !get_permissions[:create_modify_events]
      redirect_to '/', notice: "Insufficient permissions."
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
    if !get_permissions[:create_modify_events]
      redirect_to '/', notice: "Insufficient permissions."
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
