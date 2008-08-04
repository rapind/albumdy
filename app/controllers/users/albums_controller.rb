class Users::AlbumsController < ResourceController::Base
  
  belongs_to :user
  actions :index, :show
  
end
