class CreateTrackVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :track_videos do |t|
      t.references :track, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true

      t.timestamps
    end
  end
end
