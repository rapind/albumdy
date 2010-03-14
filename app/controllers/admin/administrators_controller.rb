class Admin::AdministratorsController < Admin::HomeController  
  inherit_resources
  actions :edit, :update
  before_filter :check_demo_mode, :only => :update
  
  # redirect to edit path on update instead of show
  def update
    @administrator = current_administrator
    if params[:id]
      # trying to update a specific administrator on a singular resource is a no-no
      flash[:notice] = "You can only update your own settings!"
      redirect_to edit_resource_path
    else
      update!{ edit_resource_path }
    end
  end
  
  def edit
    @administrator = current_administrator
  end
  
  private #-----
  
  def check_demo_mode
    if defined?(DEMO_MODE) and DEMO_MODE
      flash[:notice] = 'Cannot modify the settings in demo mode.'
      redirect_to edit_admin_administrator_path
    end
  end
  
end
