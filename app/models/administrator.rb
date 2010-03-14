class Administrator < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end
  
  has_many :albums, :dependent => :destroy, :order => 'position'
  
  validates_presence_of :email, :site_name
  validates_length_of :site_name, :within => 3..64
  validates_length_of :site_email, :within => 5..100, :allow_blank => true
  validates_length_of :blog_url, :within => 10..255, :allow_blank => true
  
  after_save :clear_cache
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_administrator_password_reset_instructions(self)
  end
  
  def deliver_welcome!(unencrypted_password)
    Notifier.deliver_administrator_welcome(self, unencrypted_password)
  end
  
  # returns the path to the theme if one has been set,
  # else returns the default theme path
  def theme_path
    # set the path to the theme
    path = File.join(RAILS_ROOT, 'themes', theme) unless theme.blank?
    # use the default theme if none has been specified, or if the specified theme doesn't exist
    path = File.join(RAILS_ROOT, 'themes', 'default') if path.blank? or !File.exists?(path)
    return path
  end
  
  # retrieve the available themes
  def self.themes
    found_themes = []
    themes_path = File.join(RAILS_ROOT, 'themes')

    Dir.glob("#{themes_path}/*").each do |theme_dir|
      if File.directory?(theme_dir)
        found_themes << File.basename(theme_dir)
      end
    end

    found_themes
  end
  
  def clear_cache
    Administrator.clear_cache
  end
  
  # clear the cached pages
  def self.clear_cache
    # clear the home page
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'index.html'))
    # clear the albums
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'albums'))
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'albums.xml'))
    # clear the sitemap
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'sitemap.xml'))
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'sitemap.html'))
  end
  
end