class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  helper_method :current_administrator_session, :current_administrator
  filter_parameter_logging :password
  before_filter :config
  
  #unless ActionController::Base.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction, :with => :render_404
  #end
  
  private #-------
    
    def render_404
      redirect_to not_found_path
    end
    
    # retrieve site configuration information
    def config
      return @config if defined?(@config)
      begin
        @config = Administrator.find(:first) #configuration is stored in the administrator model for now (simple)
      rescue Exception => e
        flash[:error] = e.message
        redirect_to config_error_path
        return
      end
    end
    
    def current_administrator_session
      return @current_administrator_session if defined?(@current_administrator_session)
      @current_administrator_session = AdministratorSession.find
    end

    def current_administrator
      return @current_administrator if defined?(@current_administrator)
      @current_administrator = current_administrator_session && current_administrator_session.record
    end
    
    def require_administrator
      unless current_administrator
        store_location
        #flash[:notice] = "You must be logged in to access this page."
        redirect_to admin_login_path
        return false
      end
    end
    
    def require_no_administrator
      if current_administrator
        store_location
        #flash[:notice] = "You must be logged out to access this page."
        redirect_to admin_path
        return false
      end
    end

    def store_location
      session[:return_to] = request.get? ? request.request_uri : request.referer
    end
    
    def clear_location
      session[:return_to] = nil
    end

    def redirect_back_or_default
      if session[:return_to]
        redirect_to session[:return_to]
        session[:return_to] = nil
      elsif request.request_uri.include?('/admin')
        redirect_to admin_albums_path
      else
        redirect_to root_path
      end
    end
    
end
