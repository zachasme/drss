require 'net/http'

class ChannelsController < ApplicationController
  def index
    @channels = auto_paging_each.to_a
  end

  ORIGIN = "https://api.dr.dk"

  private
    def auto_paging_each(&blk)
      return enum_for(:auto_paging_each) unless block_given?

      url = ORIGIN + "/radio/v2/search/series";
      loop do
        response = Net::HTTP.get(URI(url), { 'x-apikey' => Rails.application.credentials.dr_api_key! })
        page = JSON.parse response
        items = page["items"]
        url = page["next"]
        
        items.each(&blk)
        break if url.nil?
        break # break on first page for now
      end
    end
end
  