class Video < ApplicationRecord
	belongs_to :user
	default_scope -> {order(created_at: :desc)}
	VALID_VIDEO_REGEX = /https:\/\/www.youtube.com\/embed\/\S+/
	validates :url, presence: true, format: { with: VALID_VIDEO_REGEX }, uniqueness: true
	validates :user_id, presence: true
	
	has_many :track_videos
	has_many :tracks, through: :track_videos

end
