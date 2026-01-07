require 'rails_helper'

RSpec.describe ListMoviesQuery do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie1) { create(:movie, title: 'Avatar', runtime: 180, rating: 8) }
  let(:movie2) { create(:movie, title: 'Batman', runtime: 120, rating: 7) }
  let(:movie3) { create(:movie, title: 'Cats', runtime: 90, rating: 5) }
  let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: 2025) }
  let!(:nomination3) { create(:nomination, movie: movie3, category: category, year: 2024) }

  describe '#results' do
    context 'without any filters' do
      it 'returns all movies for the year ordered by title' do
        query = described_class.new({}, user, 2025)

        result = query.results

        expect(result).to eq([movie1, movie2])
        expect(result).not_to include(movie3)
      end
    end

    context 'with search query' do
      it 'returns movies matching the title' do
        query = described_class.new({ query: 'avatar' }, user, 2025)

        result = query.results

        expect(result).to include(movie1)
        expect(result).not_to include(movie2)
      end
    end

    context 'with filter_by unwatched' do
      let!(:review) { create(:review, user: user, movie: movie1) }

      it 'returns only unwatched movies' do
        query = described_class.new({ filter_by: 'unwatched' }, user, 2025)

        result = query.results

        expect(result).to include(movie2)
        expect(result).not_to include(movie1)
      end
    end

    context 'with filter_by watched' do
      let!(:review) { create(:review, user: user, movie: movie1) }

      it 'returns only watched movies' do
        query = described_class.new({ filter_by: 'watched' }, user, 2025)

        result = query.results

        expect(result).to include(movie1)
        expect(result).not_to include(movie2)
      end
    end

    context 'with sort_by duration' do
      it 'returns movies sorted by runtime descending' do
        query = described_class.new({ sort_by: 'duration' }, user, 2025)

        result = query.results

        expect(result.first).to eq(movie1)
        expect(result.last).to eq(movie2)
      end
    end

    context 'with sort_by shortest' do
      it 'returns movies sorted by runtime ascending' do
        query = described_class.new({ sort_by: 'shortest' }, user, 2025)

        result = query.results

        expect(result.first).to eq(movie2)
        expect(result.last).to eq(movie1)
      end
    end

    context 'with sort_by imdb_rating' do
      it 'returns movies sorted by rating descending' do
        query = described_class.new({ sort_by: 'imdb_rating' }, user, 2025)

        result = query.results

        expect(result.first).to eq(movie1)
        expect(result.last).to eq(movie2)
      end
    end

    context 'with sort_by my_rating' do
      let!(:review1) { create(:review, user: user, movie: movie1, stars: 5) }
      let!(:review2) { create(:review, user: user, movie: movie2, stars: 9) }

      it 'returns movies sorted by user rating descending' do
        query = described_class.new({ sort_by: 'my_rating' }, user, 2025)

        result = query.results

        expect(result.first).to eq(movie2)
        expect(result.last).to eq(movie1)
      end
    end

    context 'without user' do
      it 'ignores user-specific filters' do
        query = described_class.new({ filter_by: 'unwatched' }, nil, 2025)

        result = query.results

        expect(result).to include(movie1, movie2)
      end
    end
  end
end
