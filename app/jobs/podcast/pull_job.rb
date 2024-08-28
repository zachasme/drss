class Podcast::PullPodcastsJob < ApplicationJob
  def perform(podcast)
    Podcast::PodcastPuller.new.pull
  end
end
