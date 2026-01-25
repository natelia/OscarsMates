require 'rails_helper'

RSpec.describe 'Factory traits' do
  describe 'User factory' do
    it 'creates admin user with :admin trait' do
      user = create(:user, :admin)
      expect(user.admin).to be true
    end

    it 'creates user with reviews using :with_reviews trait' do
      user = create(:user, :with_reviews, reviews_count: 2)
      expect(user.reviews.count).to eq(2)
    end

    it 'creates user with favorites using :with_favorites trait' do
      user = create(:user, :with_favorites, favorites_count: 2)
      expect(user.favorites.count).to eq(2)
    end

    it 'creates user with followers using :with_followers trait' do
      user = create(:user, :with_followers, followers_count: 2)
      expect(user.followers.count).to eq(2)
    end
  end

  describe 'Movie factory' do
    it 'creates movie with reviews using :with_reviews trait' do
      movie = create(:movie, :with_reviews, reviews_count: 3)
      expect(movie.reviews.count).to eq(3)
    end

    it 'creates movie with nomination using :with_nomination trait' do
      movie = create(:movie, :with_nomination, nomination_year: 2024)
      expect(movie.nominations.count).to eq(1)
      expect(movie.nominations.first.oscar_year_id).to eq(2024)
    end

    it 'creates movie with genres using :with_genres trait' do
      movie = create(:movie, :with_genres, genres_count: 3)
      expect(movie.genres.count).to eq(3)
    end

    it 'creates highly rated movie with :highly_rated trait' do
      movie = create(:movie, :highly_rated)
      expect(movie.rating).to eq(9.0)
    end
  end

  describe 'Review factory' do
    it 'creates review with comment using :with_comment trait' do
      review = create(:review, :with_comment)
      expect(review.comment).to be_present
    end

    it 'creates excellent review using :excellent trait' do
      review = create(:review, :excellent)
      expect(review.stars).to eq(10)
      expect(review.comment).to be_present
    end

    it 'creates poor review using :poor trait' do
      review = create(:review, :poor)
      expect(review.stars).to eq(2)
    end
  end

  describe 'Category factory' do
    it 'creates Best Picture category with :best_picture trait' do
      category = create(:category, :best_picture)
      expect(category.name).to eq('Best Picture')
    end

    it 'creates category with nominations using :with_nominations trait' do
      category = create(:category, :with_nominations, nominations_count: 3)
      expect(category.nominations.count).to eq(3)
    end
  end

  describe 'Genre factory' do
    it 'creates Drama genre with :drama trait' do
      genre = create(:genre, :drama)
      expect(genre.name).to eq('Drama')
    end
  end
end
