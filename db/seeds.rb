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
albums << administrator.albums.create(:position => 1, :title => 'Family', :keywords => "portfolio, professional, photography, album, photo, client, workflow, management, booking, ruby, rails", :description => "GrokPhoto is an open-source professional administrator album, client manager, booking manager, and photo system. Add as many albums and pages as you like to your site once it's been setup.")
albums << administrator.albums.create(:position => 2, :title => 'Newborn', :keywords => "professional, photography, album, photo, client, workflow, management, booking, ruby, rails", :description => "You can create bookings for your clients, upload multiple photos to a booking with one click, and then send out a custom invite message giving your client secure access.")
albums << administrator.albums.create(:position => 3, :title => 'Babies and Children', :keywords => "themes, professional, photography, album, photo, client, workflow, management, booking, ruby, rails", :description => "You can create your own themes. All you need is a little HTML knowledge, or even better some Ruby on Rails experience to create more advanced themes.")
albums << administrator.albums.create(:position => 4, :title => 'Maternity', :keywords => "opensource, professional, photography, album, photo, client, workflow, management, booking, ruby, rails", :description => "GrokPhoto is completely open-source. This means if you know a little bit about coding (or someone who does), you can have your own version and theme up and running within a few minutes. The engine behind GrokPhoto is Ruby on Rails.")
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

