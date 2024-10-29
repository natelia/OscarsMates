class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :english_title
      t.string :where_to_watch
      t.integer :runtime
      t.float :rating
      t.string :url
      t.string :picture_url

      t.timestamps
    end
  end
end
