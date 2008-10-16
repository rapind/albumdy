class UsersController < ResourceController::Base
  
  actions :index, :new, :create, :activate, :forget_password, :reset_password
  
  # registration
  def new
    @page_title = 'Membership Signup'
    @page_description = "If this is your first time here, you can sign up for a new account below. Once signed in you can upload and manage your own photo albums."
    @user = User.new
  end

  # create new user from registration
  def create
    @page_title = 'Membership Signup'
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
  
  # activate from email link
  def activate
    @page_title = 'Membership Activation'
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete"
    else
      flash[:alert] = "Signup Failure"
    end
    redirect_to root_path
  end
  
  # send a password reset code to the user's email address
  def forgot_password
    @page_title = 'Forgot Password'
    return unless request.post?
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      redirect_to root_path
      flash[:notice] = "A password reset link has been sent to your email address" 
    else
      flash[:alert] = "Could not find a user with that email address" 
    end
  end

  # reset password from email link
  def reset_password
    @page_title = 'Reset Password'
    @user = User.find_by_password_reset_code(params[:id])
    return if @user unless params[:user]

    if ((params[:user][:password] && params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @user.reset_password
      flash[:notice] = current_user.save ? "Password reset success." : "Password reset failed." 
      redirect_to root_path
    else
      flash[:alert] = "Password mismatch" 
    end
  end
  
  protected #--------------------

  def find_user
    @user = User.find(params[:id])
  end
  
  private #--------------

  # Defining the collection explicitly for paging and limit to visible users
  def collection
    @collection ||= end_of_association_chain.paginate :conditions => 'visible = 1', :page => params[:page], :per_page => 10, :order => 'created_at DESC'
  end
  
end
