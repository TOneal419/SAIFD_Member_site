# frozen_string_literal: true

# EventsController
class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
    @perms = grab_permissions
  end

  # GET /events/1 or /events/1.json
  def show
    return redirect_to '/', notice: 'Attempted to access disabled route.'
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
    if @event.event_time_start > @event.event_time_end
        flash[:alert] = "Event must start before it ends"
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
      flash[:alert] = "Event must start before it ends"
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
