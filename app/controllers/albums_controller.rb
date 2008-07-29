class AlbumsController < ResourceController::Base
  
  update.flash 'Album successfully updated.'
  destroy.flash 'Album successfully removed.'
  
end
