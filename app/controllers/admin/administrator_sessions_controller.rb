class Admin::AdministratorSessionsController < Admin::HomeController
  before_filter :require_no_administrator, :except => :destroy
  skip_before_filter :require_administrator, :except => :destroy
  
  def new
    @administrator_session = AdministratorSession.new
  end

  def create
    @administrator_session = AdministratorSession.new(params[:administrator_session])
    if @administrator_session.save
      flash[:notice] = "Administrator Login successful!"
      redirect_back_or_default
    else
      render :action => :new
    end
  end

  def destroy
    session[:return_to] = request.referer
    current_administrator_session.destroy
    flash[:notice] = "Administrator Logout successful!"
    redirect_to new_admin_administrator_session_url
  end
end
