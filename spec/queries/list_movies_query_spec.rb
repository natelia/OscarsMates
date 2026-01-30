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

      it 'excludes movies with unrated reviews from watched' do
        create(:review, user: user, movie: movie2, stars: nil)
        query = described_class.new({ filter_by: 'unwatched' }, user, 2025)

        result = query.results

        expect(result).to include(movie2) # Unrated = unwatched
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

      it 'excludes movies with only unrated reviews' do
        create(:review, user: user, movie: movie2, stars: nil)
        query = described_class.new({ filter_by: 'watched' }, user, 2025)

        result = query.results

        expect(result).to include(movie1)
        expect(result).not_to include(movie2) # Unrated = not watched
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

        result = query.results.to_a

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

    context 'with sort_by most_nominated' do
      let(:category2) { create(:category) }
      let(:category3) { create(:category) }

      before do
        # movie1 has 1 nomination (from base setup)
        # movie2 has 3 nominations
        create(:nomination, movie: movie2, category: category2, year: 2025)
        create(:nomination, movie: movie2, category: category3, year: 2025)
      end

      it 'returns movies sorted by nomination count descending' do
        query = described_class.new({ sort_by: 'most_nominated' }, user, 2025)

        result = query.results.to_a

        # movie2 should appear before movie1 since it has more nominations
        movie1_index = result.index(movie1)
        movie2_index = result.index(movie2)
        expect(movie2_index).to be < movie1_index
      end

      it 'includes nominations_count attribute' do
        query = described_class.new({ sort_by: 'most_nominated' }, user, 2025)

        result = query.results.to_a

        movie2_result = result.find { |m| m.id == movie2.id }
        movie1_result = result.find { |m| m.id == movie1.id }

        expect(movie2_result['nominations_count'].to_i).to eq(3)
        expect(movie1_result['nominations_count'].to_i).to eq(1)
      end

      it 'only counts nominations for the specified year' do
        # movie3 has a 2024 nomination, should not be counted for 2025
        query = described_class.new({ sort_by: 'most_nominated' }, user, 2025)

        result = query.results

        expect(result).not_to include(movie3)
      end
    end

    context 'with category_id filter' do
      let(:category2) { create(:category, name: 'Best Director') }
      let!(:nomination_movie2_cat2) { create(:nomination, movie: movie2, category: category2, year: 2025) }

      it 'returns only movies nominated in the specified category' do
        query = described_class.new({ category_id: category2.id }, user, 2025)

        result = query.results

        expect(result).to include(movie2)
        expect(result).not_to include(movie1)
      end

      it 'filters by both category and year' do
        # Create a 2024 nomination for movie1 in category2
        create(:nomination, movie: movie1, category: category2, year: 2024)

        query = described_class.new({ category_id: category2.id }, user, 2025)

        result = query.results

        expect(result).to include(movie2)
        expect(result).not_to include(movie1) # movie1's nomination is for 2024
      end

      it 'works with other filters' do
        create(:review, user: user, movie: movie2, stars: 8)

        query = described_class.new({ category_id: category2.id, filter_by: 'watched' }, user, 2025)

        result = query.results

        expect(result).to include(movie2)
      end

      it 'works with sorting' do
        movie4 = create(:movie, title: 'Dune', runtime: 155, rating: 8.5)
        create(:nomination, movie: movie4, category: category2, year: 2025)

        query = described_class.new({ category_id: category2.id, sort_by: 'imdb_rating' }, user, 2025)

        result = query.results.to_a

        expect(result.first).to eq(movie4) # rating 8.5
        expect(result.last).to eq(movie2)  # rating 7
      end
    end
  end
end
