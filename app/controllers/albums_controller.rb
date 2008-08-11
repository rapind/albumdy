class AlbumsController < ResourceController::Base

  belongs_to :user
  
  actions :index, :show
  
  index.flash 'Albums'
  show.flash 'Album'
  
  private #--------------
  
  # Explicitly defined for paging, to limit the visible albums, and to set the appropriate page title and description
  def collection
    @collection ||= end_of_association_chain.paginate :conditions => 'visible = 1', :page => params[:page], :per_page => 4, :order => 'created_at DESC'
    
    @page_title = 'Shared Albums'
    @page_description = "Click on an album to see it's photos. Use the next and previous links to page through the list of albums."
    
    return @collection
  end
  
  # Explicitly defined to set the appropriate page title and description
  def object
    # run the query
    @object ||= end_of_association_chain.find(param)
    
    @page_title = @object.title
    @page_description = "Click on a photo to see it's original resolution. Use the next and previous links to move through the list of photos."
    
    return @object
  end
  
end
