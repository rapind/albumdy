class Album < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  acts_as_list :scope => :user
  
  has_many :photos, :dependent => :destroy, :order => 'position'
  
  validates_presence_of :user, :title
  validates_length_of :title, :within => 5..128
  validates_length_of :description, :within => 20..500, :allow_nil => true, :allow_blank => true
  
  has_friendly_id :title, :use_slug => true, :strip_diacritics => true
  
  
  # used as album cover
  def photo
    self.photos.find :first, :order => 'position' rescue nil
  end
  
  def public_photos
    self.photos.find :all, :limit => 9, :order => 'position'
  end
  
end
