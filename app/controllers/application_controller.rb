# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  # make sure user is authenticated EXCEPT when creating a new user (/user#new/ which has been routed to /auth/sign_up)
  before_action :authenticate_admin!, except: [:users] 
end
