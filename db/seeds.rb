# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Movie.create!( [

  { title: "Movie 1", english_title: "English Movie 1", where_to_watch: "Netflix", runtime: 120, rating: 7.5, url: "http://example.com/movie1", picture_url: "http://example.com/picture1.jpg" },

  { title: "Movie 2", english_title: "English Movie 2", where_to_watch: "Hulu", runtime: 105, rating: 8.0, url: "http://example.com/movie2", picture_url: "http://example.com/picture2.jpg"},
  # Add more movie data as needed
])
