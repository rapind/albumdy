class AlbumsController < ResourceController::Base
  
  update.flash 'Album successfully updated.'
  destroy.flash 'Album successfully removed.'
  
  def update_photo_position

    @album = Album.find(params[:id])
    
    if params[:photo_id] and params[:position] and !@album.blank?
      photo = @album.photos.find(params[:photo_id])
      photo.insert_at(params[:position].to_i)
    end
    
    render :text => 'Success'
  end
  
end
