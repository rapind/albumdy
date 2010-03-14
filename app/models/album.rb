class Album < ActiveRecord::Base
  belongs_to :administrator
  acts_as_list :scope => :administrator_id
  
  has_many :photos, :dependent => :destroy, :order => 'position'
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  validates_length_of :title, :within => 2..100
  validates_length_of :description, :within => 5..1000
  validates_length_of :keywords, :within => 3..200, :allow_blank => true
  
  has_attached_file :image,
                    :styles => { :original => "", :thumb => "" },
                    :path => ":rails_root/public/attachments/albums/:id/:style/:basename.:extension",
                    :url => "/attachments/albums/:id/:style/:basename.:extension",
                    :convert_options => {
                      :original => "-gravity center -thumbnail 960x540^ -extent 960x540",
                      :thumb => "-gravity center -thumbnail 150x100^ -extent 150x100"
                    }
  
  #validates_attachment_content_type :image, :content_type => ['image/jpeg']
  
  has_friendly_id :title, :use_slug => true
  
  after_save :clear_cache
  
  # clear the cached pages
  def clear_cache
    Administrator.clear_cache
  end
  
end
