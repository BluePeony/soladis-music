class AddCategoryToTracks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tracks, :category foreign_key: true
  end
end
