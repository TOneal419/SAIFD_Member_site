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

    # TODO: test putting malicious email params in URL initially

    # puts "::::HERE::::"
    # puts @google_email
    # puts !params.has_key?(:google_email)
    # puts @google_email.nil?
    # puts @google_email.strip.empty?
    # puts !@google_email
    # # implies that something went wrong with OAuth OR malicious
    # if !params.has_key?(:google_email) || @google_email.nil? || @google_email.strip.empty? || !@google_email
    #   puts "RENDER INDEX HERE"
    #   render :index
    # end

    @google_pfp = params['google_pfp']
    @google_name = params['google_name']
    @google_names = nil

    @user = nil

    if !@google_name.nil?
      @google_names = @google_name.split
      @user = User.new(email: @google_email, first_name: @google_names[0], last_name: @google_names[1])
    end

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
    # TODO: make sure everything routes to the proper places in User form
    @user = User.new(user_params)
    @user.update(role_id: 0) # ENSURE that privilleges are 0 (aka normal user)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
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
      params.require(:user).permit(:email, :first_name, :last_name, :class_year, :role_id, :user_id)
    end
end
