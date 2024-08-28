class Podcast < ApplicationRecord
  has_many :episodes

  scope :alphabetical, -> { order(:name) }
end
