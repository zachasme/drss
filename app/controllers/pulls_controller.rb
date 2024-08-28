class PullsController < ApplicationController
  def create
    Podcast::PodcastPuller.new.pull
  end
end
