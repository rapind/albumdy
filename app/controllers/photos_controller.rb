class PhotosController < ResourceController::Base
  
  belongs_to :album
  
  before_filter :login_required, :only => [:new, :edit, :update]
  
  # find the latest photo for the album matching the filename
  def thumb
    @album = Album.find(params[:album_id])
    filename = params[:filename]
    @photo = @album.photos.find(:first, :conditions => [ "image_file_name = ?", filename ], :order => 'created_at DESC')
  end
  
  # update an individual photo's position
  def update_position
    @album = current_user.albums.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @photo.insert_at(params[:position].to_i)
    
    render :text => 'Success'
  end
  
  create.flash 'Photo was successfully added.'
  update.flash 'Photo was successfully updated.'
  destroy.flash 'Photo was successfully removed.'
  
  # redirect to the user album instead of show on update and destroy
  [update, destroy, create].each { |action| action.wants.html { redirect_to edit_photos_user_album_path(current_user, @album) } }
  
  index.wants.rss  { render :layout => false } # uses index.rss.builder
  
  
  private
  
    # Defining the collection explicitly for paging / ordering
    def collection
      @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => 10, :order => 'position'
    end
    
end