class RemoveTrackTitlesFromVideos < ActiveRecord::Migration[6.1]
  def change
    remove_column :videos, :track_titles, :text
  end
end
