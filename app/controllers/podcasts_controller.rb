class PodcastsController < ApplicationController
  def index
    @podcasts = Podcast.alphabetical
  end

  def show
    @podcast = Podcast.find(params[:id])
  end
end
