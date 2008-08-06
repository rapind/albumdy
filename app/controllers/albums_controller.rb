class AlbumsController < ResourceController::Base

  belongs_to :user
  
  actions :index, :show
  
  index.flash 'Albums'
  show.flash 'Album'
  
  private #--------------

  # Defining the collection explicitly for paging and limit to visible albums
  def collection
    @collection ||= end_of_association_chain.paginate :conditions => 'visible = 1', :page => params[:page], :per_page => 4, :order => 'created_at DESC'
  end
  
end
