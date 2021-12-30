class AddDescriptionToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :description, :text
  end
end
