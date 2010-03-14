class HomeController < ApplicationController
  layout 'layout' #kind of a cheat so we don't need to use a layouts directory in the themes folders
  skip_before_filter :config, :only => :config_error
  before_filter :prepend_theme, :except => :config_error # applies a theme
  before_filter :load_albums
  
  caches_page :index
  
  def config_error
    render :layout => false, :template =>  '/config_error.html'
  end
  
  # landing page
  def index
    @albums = @config.albums.find :all
    render :template => '/home'
  end
  
  def not_found
    render :template => '/404', :status => :not_found
  end
  
  private #------
  
    # prepend the chosen (or default) theme
    def prepend_theme
      self.prepend_view_path(config.theme_path)
    end
    
    def load_albums
      @albums = config.albums.all
    end
    
end