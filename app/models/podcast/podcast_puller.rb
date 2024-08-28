require "net/http"

class Podcast::PodcastPuller
  def pull
    auto_paging_each do |item|
      podcast = Podcast.find_or_initialize_by(guid: item["id"])
      podcast.name = item["title"]
      podcast.description = item["description"]
      podcast.explicit = item["explicitContent"]
      podcast.category = item["categories"].first || ""
      podcast.image_url = image(item["imageAssets"])
      podcast.punchline = item["punchline"] || ""
      podcast.save
    end
  end

  private
    def auto_paging_each(&blk)
      return enum_for(:auto_paging_each) unless block_given?

      url = "https://api.dr.dk/radio/v2/search/series"
      loop do
        response = Net::HTTP.get(URI(url), { "x-apikey" => Rails.application.credentials.dr_api_key! })
        page = JSON.parse response
        items = page["items"]
        url = page["next"]

        items.each(&blk)
        puts url
        break if url.nil?
      end
    end

    def image(assets)
      # https://asset.dr.dk/imagescaler/?protocol=https&server=api.dr.dk&file=%2Fradio%2Fv2%2Fimages%2Fraw%2Furn%3Adr%3Aradio%3Aimage%3A63162deae354a45e20d1daf7&scaleAfter=crop&quality=70&w=720&h=720
      prefix = "https://asset.dr.dk/imagescaler/?protocol=https&server=api.dr.dk&file="
      suffix = "&scaleAfter=crop&quality=70&w=720&h=720"

      asset = assets.find do |asset|
        asset["target"] == "SquareImage"
      end

      prefix + URI.encode_www_form_component("/radio/v2/images/raw/" + asset["id"]) + suffix
    end
end
