class AddIndexToTracksTitle < ActiveRecord::Migration[6.1]
  def change
  	add_index :tracks, :title, unique: true
  end
end
