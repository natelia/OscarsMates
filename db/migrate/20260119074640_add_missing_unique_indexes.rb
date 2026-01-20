class AddMissingUniqueIndexes < ActiveRecord::Migration[7.1]
  def change
    # Unique index for reviews (one review per user per movie)
    add_index :reviews, %i[user_id movie_id], unique: true, if_not_exists: true

    # Unique index for movie slugs
    add_index :movies, :slug, unique: true, if_not_exists: true

    # Unique index for nominations (one nomination per movie per category per year)
    add_index :nominations, %i[movie_id category_id year],
              unique: true,
              name: 'index_nominations_on_movie_category_year',
              if_not_exists: true

    # Unique index for favorites (one favorite per user per movie)
    add_index :favorites, %i[user_id movie_id], unique: true, if_not_exists: true

    # Unique index for characterizations (one genre per movie)
    add_index :characterizations, %i[movie_id genre_id], unique: true, if_not_exists: true

    # Unique index for category names
    add_index :categories, :name, unique: true, if_not_exists: true
  end
end
