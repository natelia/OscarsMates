require 'rails_helper'

RSpec.describe MovieFilteringService do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:watched_movie) { create(:movie, title: 'Watched Movie') }
  let(:unwatched_movie) { create(:movie, title: 'Unwatched Movie') }
  let!(:nomination1) { create(:nomination, movie: watched_movie, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: unwatched_movie, category: category, year: 2025) }
  let!(:review) { create(:review, user: user, movie: watched_movie) }

  describe '.call' do
    context 'with unwatched filter' do
      it 'returns only movies the user has not reviewed' do
        movies = Movie.all

        result = described_class.call(movies: movies, user: user, filter: 'unwatched')

        expect(result).to be_success
        expect(result.data).to include(unwatched_movie)
        expect(result.data).not_to include(watched_movie)
      end

      it 'returns all movies when user has no reviews' do
        user_without_reviews = create(:user)
        movies = Movie.all

        result = described_class.call(movies: movies, user: user_without_reviews, filter: 'unwatched')

        expect(result).to be_success
        expect(result.data).to include(watched_movie, unwatched_movie)
      end
    end

    context 'without filter' do
      it 'returns all movies' do
        movies = Movie.all

        result = described_class.call(movies: movies, user: user)

        expect(result).to be_success
        expect(result.data).to include(watched_movie, unwatched_movie)
      end
    end
  end
end
