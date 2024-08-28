class Podcast::RefreshEpisodesJob < ApplicationJob
  def perform(podcast)
    Podcast::EpisodeRefresher.new(podcast:).refresh
  end
end
