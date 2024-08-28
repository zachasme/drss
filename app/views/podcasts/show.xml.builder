xml.instruct! :xml, version: "1.0"
xml.instruct! "xml-stylesheet", type: "text/xsl", href: asset_path("podcast.xsl")
xml.rss version: "2.0",
        "xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd",
        "xmlns:content": "http://purl.org/rss/1.0/modules/content/" do
  xml.channel do
    xml.title @podcast.name
    xml.link podcast_url(@podcast)
    xml.language "da-dk"
    xml.copyright "DR"
    xml.itunes :author, "DR"
    xml.description @podcast.description
    xml.itunes :type, "serial"
    xml.itunes :image, "serial"
    xml.itunes :category, @podcast.category
    xml.itunes :explicit, false

    @podcast.episodes.each do |episode|
      xml.item do
        xml.itunes :episode_type, "full"
        xml.itunes :title, episode.name
        xml.description episode.description
        xml.enclosure length: episode.file_size,
                      type: "audio/mpeg",
                      url: episode.file_url
        xml.guid episode.guid
        xml.pubDate episode.published_at.rfc822
        xml.itunes :duration, episode.duration
        xml.itunes :explicit, episode.explicit
      end
    end
  end
end
