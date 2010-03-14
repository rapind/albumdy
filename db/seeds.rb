puts "Creating administrator"
administrator = Administrator.create(
  :email => "demo@albumdy.org",
  :password => "password",
  :site_name => 'Albumdy', 
  :site_email => 'info@albumdy.org',
  :blog_url => 'http://rapin.com',
  :theme => 'default',
  :google_analytics_key => 'UA-2450369-24'
)
administrator.save

puts "Creating albums"
albums = []
albums << administrator.albums.create(:position => 1, :title => 'Family', :keywords => "portfolio, photography, album, photo, ruby, rails, open-source, themes", :description => "Albumdy is a very simple open-source album and photo management application, built with Ruby on Rails.")
albums << administrator.albums.create(:position => 2, :title => 'Newborn', :keywords => "portfolio, photography, album, photo, ruby, rails, open-source, themes", :description => "Log into the administration area and add as many albums and photos as you like to your site once it's been setup.")
albums << administrator.albums.create(:position => 3, :title => 'Babies and Children', :keywords => "portfolio, photography, album, photo, ruby, rails, open-source, themes", :description => "You can also create your own themes. All you need is a little HTML knowledge, or even better some Ruby on Rails experience to create more advanced themes.")
albums << administrator.albums.create(:position => 4, :title => 'Maternity', :keywords => "portfolio, photography, album, photo, ruby, rails, open-source, themes", :description => "These slide images are also completely customizable via the administration area. Log in now at demo.albumdy.org/admin and give it a try.")
puts "Uploading album images..."
base_dir = File.join(RAILS_ROOT, "photoshop/albums/")
for album in albums
  file_name = "#{album.friendly_id}.jpg"
  file_path = "#{base_dir}#{file_name}"
  puts "uploading #{file_path}"
  album.image = File.new(file_path) rescue nil
  album.save
end

puts "Uploading photo images"
base_dir = File.join(RAILS_ROOT, "photoshop/albums")
for album in albums
  photos_dir = File.join(RAILS_ROOT, "photoshop/albums/#{album.title.downcase.gsub(' ', '-')}/")
  file_names = Dir.glob("#{photos_dir}*.jpg")
  file_names.each_with_index do |file_name, idx|
    puts "uploading #{file_name}"
    album.photos.create(:position => (idx + 1), :image => File.new(file_name)) rescue nil
  end
end

