class Album < ActiveRecord::Base
  
  belongs_to :user, :counter_cache => true
  acts_as_list :scope => :user
  
  has_many :photos, :dependent => :destroy, :order => 'position'
  
end
