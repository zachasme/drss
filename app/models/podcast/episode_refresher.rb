require "net/http"

class Podcast::EpisodeRefresher
  attr_reader :podcast

  def initialize(podcast)
    @podcast = podcast
  end

  def refresh
    auto_paging_each do |item|
      audio = best_audio item["audioAssets"]

      episode = podcast.episodes.find_or_initialize_by(guid: item["productionNumber"])
      episode.name = item["title"]
      episode.description = item["description"]
      episode.file_size = audio["fileSize"]
      episode.file_url = audio["url"]
      episode.published_at = item["publishTime"]
      episode.duration = item["duration"]
      episode.explicit = item["explicitContent"]

      episode.save
    end
  end

  private
    def auto_paging_each(&blk)
      return enum_for(:auto_paging_each) unless block_given?

      url = "https://api.dr.dk/radio/v2/series/#{podcast.guid}/episodes"
      loop do
        response = Net::HTTP.get(URI(url), { "x-apikey" => Rails.application.credentials.dr_api_key! })
        page = JSON.parse response
        items = page["items"]
        url = page["next"]


        items.each(&blk)
        break if url.nil?
      end
    end


    def best_audio(assets)
      assets.find do |asset|
        asset["format"] === "mp3" && asset["bitrate"] === 192
      end || assets.first
    end
end
