class AddUsedTracksToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :used_tracks, :text
  end
end
