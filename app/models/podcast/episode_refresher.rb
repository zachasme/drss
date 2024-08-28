class Podcast::EpisodeRefresher
  attr_reader :podcast

  def initialize(podcast)
    @podcast = podcast
  end

  def refresh
    auto_paging_each do |item|
      episode = podcast.episodes.find_or_initialize_by(guid: item["productionNumber"])
      episode.name = item["title"]
      episode.description = item["description"]
      episode.file_size = 0
      episode.file_url = ""
      episode.published_at = item["publishTime"]
      episode.duration = item["duration"]
      episode.explicit = item["explicitContent"]

      episode.save
      puts "@@@"
      puts episode
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
        break # break on first page for now
      end
    end
end
