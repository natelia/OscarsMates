class AddSlugToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :slug, :string
  end
end
