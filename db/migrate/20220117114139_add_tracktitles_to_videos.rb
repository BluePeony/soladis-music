class AddTracktitlesToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :track_titles, :text
  end
end
