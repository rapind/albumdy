class AlbumsController < ResourceController::Base
  
  def show
    @album = Album.find(params[:id])
  end
  
end
