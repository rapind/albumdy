class Manage::UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required
  
  def destroy
    user = current_user
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    user.destroy!
    flash[:notice] = "You have been removed from the system and logged out"
    redirect_to root_path
  end
  
  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]

        if current_user.save
          flash[:notice] = "Password successfully updated" 
          redirect_to manage_user_path(current_user)
        else
          flash[:alert] = "Password not changed" 
        end

      else
        flash[:alert] = "New Password mismatch" 
        @old_password = params[:old_password]
      end
    else
      flash[:alert] = "Old password incorrect" 
    end
  end

end
