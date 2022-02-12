class Admins::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      admin = Admin.from_google(**from_google_params)
  
      if admin.present?
        userExists = !User.where(email: admin.email).blank?

        # if user exists, log them into the dashboard
        if userExists
          sign_out_all_scopes
          flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
          sign_in_and_redirect admin, event: :authentication
        
        # otherwise, have them fill out other required fields (ie: class year)
        else
          redirect_to new_user_path(:google_email => admin.email, :google_name => admin.full_name, :google_pfp => admin.avatar_url)
        end
        
      else
        flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
        redirect_to new_admin_session_path
      end
    end
  
    protected
  
    def after_omniauth_failure_path_for(_scope)
      new_admin_session_path
    end
  
    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || root_path
    end
  
    private
  
    def from_google_params
      @from_google_params ||= {
        uid: auth.uid,
        email: auth.info.email,
        full_name: auth.info.name,
        avatar_url: auth.info.image
      }
    end
  
    def auth
      @auth ||= Rails.application.env_config["omniauth.auth"] || request.env['omniauth.auth']
    end
  end