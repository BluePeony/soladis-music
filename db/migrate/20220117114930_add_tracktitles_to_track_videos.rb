class AddTracktitlesToTrackVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :track_videos, :track_titles, :text
  end
end
