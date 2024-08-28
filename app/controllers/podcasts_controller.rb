require "net/http"

class PodcastsController < ApplicationController
  def index
    auto_paging_each do |item|
      podcast = Podcast.find_or_initialize_by(guid: item["id"])
      podcast.name = item["title"]
      podcast.description = item["description"]
      podcast.explicit = item["explicitContent"]
      podcast.category = item["categories"].first
      podcast.save
    end
    @podcasts = Podcast.all
  end

  def show
    @podcast = Podcast.find(params[:id])
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
end
