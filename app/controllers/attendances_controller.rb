# frozen_string_literal: true

# AttendancesController
class AttendancesController < ApplicationController
    before_action :set_attendance, only: %i[ show edit update destroy ]

    # GET /attendances or /attendances.json
    def index
      # by default, only grab current user's attendance
      @user = get_user
      @attendances = Attendance.where(user_id: @user.id)

      if get_permissions[:view_all_attendances]
        @attendances = Attendance.all
      end

      @perms = get_permissions
    end

    # GET /attendances/1 or /attendances/1.json
    def show
      redirect_to '/', notice: "Attempted to access disabled route."
    end

    # GET /attendances/new
    def new
      @attendance = Attendance.new
    end

    # GET /attendances/1/edit
    def edit
      if attendance_params["attend_time_start"] > attendance_params["attend_time_end"]
        redirect_to '/attendances/new', notice: "Attendance must begin before it ends"
      end
    end

    # POST /attendances or /attendances.json
    def create
      @redirected = false
      if attendance_params["attend_time_start"] > attendance_params["attend_time_end"]
        @redirected = true
        redirect_to '/attendances/new', notice: "Attendance must begin before it ends"
      end

      if !@redirected
        @attendance = Attendance.new(attendance_params)
        @user = get_user

        @attendance.update(user_id: @user.id)

        respond_to do |format|
          if @attendance.save
            format.html { redirect_to attendances_path, notice: "Attendance was successfully created." }
            format.json { render :index, status: :created, location: @attendance }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @attendance.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  

    # PATCH/PUT /attendances/1 or /attendances/1.json
    def update
        respond_to do |format|
          if @attendance.update(attendance_params)
            format.html { redirect_to attendances_path, notice: 'Attendance was successfully updated.' }
            format.json { render :index, status: :ok, location: @attendance }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @attendance.errors, status: :unprocessable_entity }
          end
        end
    end

    # DELETE /attendances/1 or /attendances/1.json
    def destroy
        @attendance.destroy

        respond_to do |format|
          format.html { redirect_to attendances_url, notice: 'Attendance was successfully destroyed.' }
          format.json { head :no_content }
        end
    end

    private

        # Use callbacks to share common setup or constraints between actions.
        def set_attendance
            @attendance = Attendance.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def attendance_params
            params.require(:attendance).permit(:event_id, :user_id, :attend_time_start, :attend_time_end, :plans_to_attend)
        end
    end
