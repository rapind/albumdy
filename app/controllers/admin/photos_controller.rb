class Admin::PhotosController < ResourceController::Base
  belongs_to :album
end