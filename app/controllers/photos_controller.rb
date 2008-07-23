class PhotosController < ApplicationController

  def create
    _find_album
    @photo = Photo.new(params[:photo])
    
    if @photo.save
      @album.photos << @photo
      flash[:notice] = "Album was successfully created."
      redirect_to albums_url
    else
      flash[:notice] = "File size cannot exceed 500 kb"
      redirect_to album_url(@album)
    end
       
  end
  
  def destroy
    _find_album
    @photo = @album.photos.find(params[:id])
    @photo.destroy
    flash[:notice] = "Photo was successfully deleted."
    redirect_to albums_url
  end
  
  
  private #-------
  
  def _find_album
    @album = Album.find(params[:album_id])
  end
  
end