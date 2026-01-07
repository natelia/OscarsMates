require 'rails_helper'

RSpec.describe MovieFilteringService do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:watched_movie) { create(:movie, title: 'Watched Movie') }
  let(:unwatched_movie) { create(:movie, title: 'Unwatched Movie') }
  let!(:nomination1) { create(:nomination, movie: watched_movie, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: unwatched_movie, category: category, year: 2025) }
  let!(:review) { create(:review, user: user, movie: watched_movie) }

  describe '#filter_unwatched' do
    it 'returns only movies the user has not reviewed' do
      movies = Movie.all
      service = described_class.new(movies, user)

      result = service.filter_unwatched

      expect(result).to include(unwatched_movie)
      expect(result).not_to include(watched_movie)
    end

    it 'returns all movies when user has no reviews' do
      user_without_reviews = create(:user)
      movies = Movie.all
      service = described_class.new(movies, user_without_reviews)

      result = service.filter_unwatched

      expect(result).to include(watched_movie, unwatched_movie)
    end
  end
end
