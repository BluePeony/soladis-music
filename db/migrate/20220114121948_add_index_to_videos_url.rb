class AddIndexToVideosUrl < ActiveRecord::Migration[6.1]
  def change
  	add_index :videos, :url, unique: true
  end
end
