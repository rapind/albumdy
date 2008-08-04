class Admin::AlbumsController < ResourceController::Base
  belongs_to :user
end