class Video < ApplicationRecord

	VALID_VIDEO_REGEX = /https:\/\/www.youtube.com\/watch\?\S+/
	validates :url, presence: true, format: { with: VALID_VIDEO_REGEX }, uniqueness: true

end
