# frozen_string_literal: true

# Permissions Controller
class PermissionsController < ApplicationController
  before_action :set_permission, only: %i[show edit update destroy]

  # GET /permissions or /permissions.json
  def index
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # GET /permissions/1 or /permissions/1.json
  def show
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # GET /permissions/new
  def new
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # GET /permissions/1/edit
  def edit
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # POST /permissions or /permissions.json
  def create
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    redirect_to '/', notice: 'Attempted to access disabled route.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permission_params
    params.require(:permission).permit(:is_admin, :create_modify_events, :create_modify_announcements, :view_all_attendances)
  end
end
