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

  describe '#sort_label' do
    it 'returns "A-Z" for nil sort_by' do
      expect(helper.sort_label(nil)).to eq('A-Z')
    end

    it 'returns "A-Z" for empty sort_by' do
      expect(helper.sort_label('')).to eq('A-Z')
    end

    it 'returns "My Rating" for my_rating' do
      expect(helper.sort_label('my_rating')).to eq('My Rating')
    end

    it 'returns "IMDB" for imdb_rating' do
      expect(helper.sort_label('imdb_rating')).to eq('IMDB')
    end

    it 'returns "Longest" for duration' do
      expect(helper.sort_label('duration')).to eq('Longest')
    end

    it 'returns "Shortest" for shortest' do
      expect(helper.sort_label('shortest')).to eq('Shortest')
    end

    it 'returns "Mates" for watched_by_mates' do
      expect(helper.sort_label('watched_by_mates')).to eq('Mates')
    end

    it 'returns "Most Watched" for most_watched_by_mates' do
      expect(helper.sort_label('most_watched_by_mates')).to eq('Most Watched')
    end

    it 'returns "Nominations" for most_nominated' do
      expect(helper.sort_label('most_nominated')).to eq('Nominations')
    end
  end
end
