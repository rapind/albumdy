xml.instruct!

xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  xml.url do
    xml.loc         "http://www.albumdy.com/"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "always"
  end

  for album in @albums
    xml.url do
      xml.loc         album_url(album)
      xml.lastmod     w3c_date(album.updated_at)
      xml.changefreq  "weekly"
      xml.priority    0.8
    end
  end
  
end