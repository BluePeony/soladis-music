class TrackVideo < ApplicationRecord
  belongs_to :track
  belongs_to :video

  validates :track_id, presence: true
end
