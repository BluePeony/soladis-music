class RemoveTrackTitlesFromTrackVideos < ActiveRecord::Migration[6.1]
  def change
    remove_column :track_videos, :track_titles, :text
  end
end
