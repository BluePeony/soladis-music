class AddIndexToCategoriesTitle < ActiveRecord::Migration[6.1]
  def change
  	add_index :categories, :title
  end
end
