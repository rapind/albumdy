class Album < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
end
