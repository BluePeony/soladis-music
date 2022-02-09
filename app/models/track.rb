class Track < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_one_attached :image
	has_one_attached :audio
	default_scope -> {order(created_at: :desc)}
	validates :title, presence: true, uniqueness: true
	validates :item_number, presence: true, uniqueness: true
	validates :user_id, presence: true
	validates :image, presence: true, content_type: { in: %w[image/jpeg image/jpg image/png image/gif], message: "must be a valid image format: JPEG, PNG or GIF" },
										size: 				{ less_than: 5.megabytes, message: "is too big. It should be less than 5 MB" }
	validates :audio, presence: true, content_type: { in: %w[audio/x-wav audio/mpeg], message: "must be a valid format: WAV or MP3"}

	has_many :track_videos
	has_many :videos, through: :track_videos
	self.per_page = 3

	# Returns a resized image for display
	def display_image
		image.variant(resize_to_limit: [650, 650])
	end
end
