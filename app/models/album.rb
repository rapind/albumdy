class Album < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  acts_as_list :scope => :user
  
  has_many :photos, :dependent => :destroy, :order => 'position'
  has_many :visible_photos, :class_name => 'Photo', :conditions => 'visible = 1', :order => 'position'
  
  has_friendly_id :title
  
end
