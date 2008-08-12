xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title(@page_title)
    xml.link(formatted_albums_url(:rss))
    xml.description(@page_description)
    xml.language('en-us')

    for album in @albums
      xml.item do
        xml.title(album.title)
        xml.category()
        xml.description(album.description)
        xml.pubDate(album.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(album_url(album))
        xml.guid(album_url(album))
      end
    end
  }
}