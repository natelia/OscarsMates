# Seed script to create test reviews for 2025 nominated movies
# Run with: rails runner db/seeds/ranking_test_data.rb
# rubocop:disable Rails/Exit

Rails.logger.debug 'Creating test reviews for 2025 ranking...'

# Get 2025 nominated movies
nominated_movies = Movie.for_year(2025)

if nominated_movies.empty?
  Rails.logger.debug 'No movies with 2025 nominations found!'
  exit
end

Rails.logger.debug do
  "Found #{nominated_movies.count} movies with 2025 nominations: #{nominated_movies.pluck(:title).join(', ')}"
end

# Get all users except admin (assuming admin is first user or has name 'admin')
users = User.where.not(name: 'admin').to_a

if users.empty?
  Rails.logger.debug 'No non-admin users found!'
  exit
end

Rails.logger.debug { "Found #{users.count} users to create reviews for" }

# Create varied reviews for different users
reviews_created = 0

users.each_with_index do |user, index|
  # Give different users different numbers of watched movies
  # to create variety in the ranking
  movies_to_review = case index % 4
                     when 0 then nominated_movies.to_a # All movies
                     when 1 then nominated_movies.limit(1).to_a # First movie only
                     when 2 then nominated_movies.offset(1).to_a # Skip first movie
                     when 3 then [] # No movies (0%)
                     end

  movies_to_review.each do |movie|
    # Skip if review already exists
    next if Review.exists?(user: user, movie: movie)

    review = Review.create!(
      user: user,
      movie: movie,
      stars: rand(1..5),
      watched_on: Time.zone.today - rand(1..30).days
    )
    reviews_created += 1
    Rails.logger.debug { "  Created review: #{user.name} watched '#{movie.title}' (#{review.stars} stars)" }
  end
end

Rails.logger.debug { "\nDone! Created #{reviews_created} new reviews." }
Rails.logger.debug "\nRanking test data summary:"
User.find_each do |user|
  count = user.watched_movies_count_for_year(2025)
  Rails.logger.debug { "  #{user.name}: #{count}/#{nominated_movies.count} movies watched" }
end
# rubocop:enable Rails/Exit
