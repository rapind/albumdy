class PhotosController < ResourceController::Base
  
  actions :index, :show
  
  index.flash 'Photos'
  show.flash 'Photo'
  
  private #--------------

  # Defining the collection explicitly for paging and limit to visible photos
  def collection
    @collection ||= end_of_association_chain.paginate :conditions => 'visible = 1 and thumbnail IS NULL', :page => params[:page], :per_page => 21, :order => 'created_at DESC'
  end
  
end