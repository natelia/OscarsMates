require 'rails_helper'

RSpec.describe MoviesHelper, type: :helper do
  let(:category) { create(:category) }
  let(:movie_no_reviews) { create(:movie, title: 'movie_no_review') }
  let(:movie_with_reviews) { create(:movie, title: 'movie_with_reviews') }
  let(:user) { create(:user) }
  let!(:nomination_no_reviews) { create(:nomination, movie: movie_no_reviews, category: category, year: 2025) }
  let!(:nomination_with_reviews) { create(:nomination, movie: movie_with_reviews, category: category, year: 2025) }
  let!(:review) { create(:review, movie: movie_with_reviews, user: user, stars: 5) }

  # Define current_year as helper uses it from controller
  def current_year
    2025
  end

  before do
    helper.define_singleton_method(:current_year) { 2025 }
  end

  describe '#average_stars' do
    it 'returns "No reviews" for movie without reviews' do
      result = helper.average_stars(movie_no_reviews)
      expect(result).to include('No reviews')
    end

    it 'returns star rating for movie with reviews' do
      result = helper.average_stars(movie_with_reviews)
      expect(result).to include('5.0 stars')
    end
  end

  describe '#watch_or_unwatch_button' do
    it 'returns "Watched!" button for unwatched movie' do
      result = helper.watch_or_unwatch_button(movie_no_reviews, nil)
      expect(result).to include('Watched!')
    end

    it 'returns "Unwatch!" button for watched movie' do
      result = helper.watch_or_unwatch_button(movie_with_reviews, review)
      expect(result).to include('Unwatch!')
    end
  end
end
