require 'rails_helper'

RSpec.describe MovieSortingService do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:short_movie) { create(:movie, title: 'Short Movie', runtime: 90) }
  let(:long_movie) { create(:movie, title: 'Long Movie', runtime: 180) }
  let!(:nomination1) { create(:nomination, movie: short_movie, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: long_movie, category: category, year: 2025) }

  describe '.call' do
    context 'when sorting by duration' do
      it 'returns movies ordered by runtime descending' do
        movies = Movie.all

        result = described_class.call(movies: movies, sort_by: 'duration', user: user)

        expect(result).to be_success
        expect(result.data.first).to eq(long_movie)
        expect(result.data.last).to eq(short_movie)
      end
    end

    context 'when sorting by watched_by_mates' do
      let(:mate) { create(:user) }
      let!(:follow) { create(:follow, follower: user, followed: mate) }
      let!(:mate_review) { create(:review, user: mate, movie: short_movie) }

      it 'returns movies ordered by mates reviews count' do
        movies = Movie.all

        result = described_class.call(movies: movies, sort_by: 'watched_by_mates', user: user)

        expect(result).to be_success
        expect(result.data.first).to eq(short_movie)
      end
    end

    context 'when sorting by most_nominated' do
      let(:category2) { create(:category) }
      let!(:extra_nomination) { create(:nomination, movie: short_movie, category: category2, year: 2025) }

      it 'returns movies ordered by nomination count' do
        movies = Movie.all

        result = described_class.call(movies: movies, sort_by: 'most_nominated', user: user)

        expect(result).to be_success
        expect(result.data.first).to eq(short_movie)
      end
    end

    context 'when sorting by default (title)' do
      it 'returns movies ordered alphabetically by title' do
        movies = Movie.all

        result = described_class.call(movies: movies, sort_by: nil, user: user)

        expect(result).to be_success
        expect(result.data.first).to eq(long_movie)
        expect(result.data.last).to eq(short_movie)
      end
    end
  end
end
