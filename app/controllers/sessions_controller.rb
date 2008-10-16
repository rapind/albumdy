# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  # render new.html.erb
  def new
    @page_title = 'Login'
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(user_albums_path(current_user))
      flash[:notice] = "Logged in successfully"
    else
      flash[:alert] = "We were unable to log you in with the login and password provided. Please double check your activation email and try again."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end  
  
end
