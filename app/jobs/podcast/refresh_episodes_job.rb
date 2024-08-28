class Podcast::RefreshEpisodesJob < ApplicationJob
  def perform(podcast)
    Podcast::Refresher.new(podcast:).refresh
  end
end
