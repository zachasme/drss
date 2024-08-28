require "net/http"

class PodcastsController < ApplicationController
  def index
    auto_paging_each do |item|
      podcast = Podcast.find_or_initialize_by(guid: item["id"])
      podcast.name = item["title"]
      podcast.description = item["description"]
      podcast.explicit = item["explicitContent"]
      podcast.category = item["categories"].first
      podcast.image_url = image(item["imageAssets"])
      podcast.save
      puts item["id"]
    end
    @podcasts = Podcast.all
  end

  def show
    @podcast = Podcast.find(params[:id])
    Podcast::EpisodeRefresher.new(@podcast).refresh
  end

  ORIGIN = "https://api.dr.dk"

  private
    def auto_paging_each(&blk)
      return enum_for(:auto_paging_each) unless block_given?

      url = ORIGIN + "/radio/v2/search/series"
      loop do
        response = Net::HTTP.get(URI(url), { "x-apikey" => Rails.application.credentials.dr_api_key! })
        page = JSON.parse response
        items = page["items"]
        url = page["next"]

        items.each(&blk)
        puts items.first.keys
        break if url.nil?
        break # break on first page for now
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
