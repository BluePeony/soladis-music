module TracksHelper

	# Renders published status information about a track - for certain development puposes only
	def index_tracks(track)
		render html: "<p style= 'color: red;'>Hier kommt der Status: #{track.published_status}</p>"
	end

end
