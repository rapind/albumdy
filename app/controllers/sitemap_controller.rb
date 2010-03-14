class SitemapController < HomeController
  
  caches_page :index
  
  def index
    @albums = @config.albums.find :all
    render :template => '/sitemap'
  end
  
end