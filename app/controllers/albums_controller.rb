class AlbumsController < ResourceController::Base

  actions :index, :show
  
  private #--------------

  # Defining the collection explicitly for paging and to only return visibles
  def collection
    @collection ||= end_of_association_chain.paginate :conditions => 'visible = true', :page => params[:page], :per_page => 10, :order => 'created_at DESC'
  end
  
end
