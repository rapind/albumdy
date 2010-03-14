class AlbumsController < HomeController
  inherit_resources
  actions :index, :show
  respond_to :html, :xml
  
  caches_page :index, :show
  
  # set the initial the background image
  def index
    index! do |format|
      format.html do
        redirect_to album_path(@config.albums.first)
        return
      end
      format.xml { render :template => '/albums', :layout => false }
    end
  end
  
  def show
    show! do
      @page_title = "#{@album.title} Album"
      @page_keywords = @album.keywords.blank? ? "#{@album.title.downcase}, album, photography, portraits, landscapes" : @album.keywords
      @page_description = @album.description
      @albums = @config.albums.find :all
      render :template => '/album'
      return
    end
  end
  
end
