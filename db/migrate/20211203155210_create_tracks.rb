class CreateTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :description
      t.string :composer
      t.string :item_number
      t.boolean :published_status, default: false
      t.datetime :published_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tracks, [:user_id, :created_at]
  end
end
