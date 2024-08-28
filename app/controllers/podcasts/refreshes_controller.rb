class Podcasts::RefreshesController < ApplicationController
  def create
    podcast = Podcast.find(params[:podcast_id])
    Podcast::EpisodeRefresher.new(podcast).refresh
    redirect_to podcast_url(podcast, format: :xml)
  end
end
