class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:show, :suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :only => [:edit, :update]
  
  def show
    @page_title = "#{@user.full_name ? @user.full_name : @user.login} Albums"
    # @page_description = ?? - TODO
    # @page_keywords = ?? - TODO
  end
  
  # render new.rhtml
  def new
    @page_title = 'Sign Up'
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    
    # check to see if this user exists but is pending
    if !@user.email.blank?
      existing = User.find(:first, :conditions => [ "email = ? AND state = 'pending'", @user.email])
      # remove the old registration if it exists
      if existing
        logger.info "Found existing pending user for #{existing.email}. Removing so they can reregister."
        existing.destroy
      end
    end
    
    raise ActiveRecord::RecordInvalid.new(@user) unless @user.valid?
    @user.register!

    flash[:notice] = "Thanks for signing up"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete"
    else
      flash[:alert] = "Signup Failure"
    end
    redirect_back_or_default('/')
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.update_attributes(params[:user])
    if @user.save!
      current_user = @user
      flash[:notice] = "Profile successfully updated" 
      redirect_to educations_path
    else
      flash[:alert] = "Profile unchanged"
      redirect_to edit_user_path(current_user)
    end
  end
  
  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]

        if current_user.save
          flash[:notice] = "Password successfully updated" 
          redirect_to profile_url(current_user.login)
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

  #gain email address
  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      redirect_back_or_default('/')
      flash[:notice] = "A password reset link has been sent to your email address" 
    else
      flash[:alert] = "Could not find a user with that email address" 
    end
  end

  #reset password
  def reset_password
    @user = User.find_by_password_reset_code(params[:id])
    return if @user unless params[:user]

    if ((params[:user][:password] && params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @user.reset_password
      flash[:notice] = current_user.save ? "Password reset success." : "Password reset failed." 
      redirect_back_or_default('/')
    else
      flash[:alert] = "Password mismatch" 
    end  
  end
  

protected #--------------------

  def find_user
    @user = User.find(params[:id])
  end

end
