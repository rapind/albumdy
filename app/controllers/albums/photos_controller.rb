class Albums::PhotosController < ResourceController::Base
  belongs_to :album
  actions :index, :show
end