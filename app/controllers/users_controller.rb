class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  
  # allows /users#new (which has been routed to /auth/sign_up) to not require authentication
  skip_before_action :authenticate_admin!, :only => [:new, :create, :show]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  @@_google_email = nil
  # GET /users/new
  def new
    # grab parameters that were passed from google_oauth2
    @google_email = params['google_email']

    # TODO: fix this
    # if @google_email.nil? || @google_email.strip.empty?
    #   return redirect_to action: "index"
    # end

    # TODO: test putting malicious email params in URL initially
    # ie: without being logged in, going to http://localhost:3000/auth/sign_up?google_email=isaacy13%40tamu.edu&google_name=Isaac+Yeang&google_pfp=https%3A%2F%2Flh3.googleusercontent.com%2Fa%2FAATXAJzAQUunvw41yV2DAKpcTTS_Q-N_LjvIkov7Yt43%3Ds96-c

    @google_pfp = params['google_pfp']
    @google_name = params['google_name']
    @google_names = @google_name.split

    @user = User.new(email: @google_email, first_name: @google_names[0], last_name: @google_names[1])

    ### helps mitigate URL tampering
    # class variable uninitialized, initialize it... no (detected) tampering
    if @@_google_email.nil?
      @@_google_email = @google_email
    
    # otherwise, @@_google_email is nil and user tried tampering, redirect back with correct parameters
    else
      if @@_google_email != @google_email
        redirect_to new_user_path(:google_email => @@_google_email, :google_name => @google_name, :google_pfp => @google_pfp)
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.update(role_id: 0) # ENSURE that privilleges are 0 (aka normal user)
    @user.update(report_rate: 'Disabled') # by default, normal users shouldn't have reports

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created. Please log in again to confirm." }
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
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
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
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
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
      params.require(:user).permit(:email, :first_name, :last_name, :class_year, :role_id, :report_rate, :user_id)
    end
end
