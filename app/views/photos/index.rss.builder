xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title(@page_title)
    xml.link(photos_url(:rss))
    xml.description(@page_description)
    xml.language('en-us')

    for photo in @photos
      xml.item do
        xml.title(photo.title)
        xml.category()
        xml.description(photo.title)
        xml.pubDate(photo.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(photo_url(photo))
        xml.guid(photo_url(photo))
      end
    end
  }
}