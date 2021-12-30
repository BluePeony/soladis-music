class RemoveDescriptionFromTracks < ActiveRecord::Migration[6.1]
  def change
    remove_column :tracks, :description, :string
  end
end
