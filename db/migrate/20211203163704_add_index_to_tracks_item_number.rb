class AddIndexToTracksItemNumber < ActiveRecord::Migration[6.1]
  def change
  	add_index :tracks, :item_number, unique: true
  end
end
