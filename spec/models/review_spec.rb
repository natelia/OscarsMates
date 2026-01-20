require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      review = build(:review, user: user, movie: movie)
      expect(review).to be_valid
    end

    it 'is invalid without stars' do
      review = build(:review, user: user, movie: movie, stars: nil)
      expect(review).not_to be_valid
    end

    it 'is invalid with stars less than 1' do
      review = build(:review, user: user, movie: movie, stars: 0)
      expect(review).not_to be_valid
      expect(review.errors[:stars]).to include('must be between 1 and 10')
    end

    it 'is invalid with stars greater than 10' do
      review = build(:review, user: user, movie: movie, stars: 11)
      expect(review).not_to be_valid
      expect(review.errors[:stars]).to include('must be between 1 and 10')
    end

    it 'is invalid without watched_on' do
      review = build(:review, user: user, movie: movie, watched_on: nil)
      expect(review).not_to be_valid
      expect(review.errors[:watched_on]).to include("can't be blank")
    end

    it 'is invalid if user has already reviewed the movie' do
      create(:review, user: user, movie: movie)
      duplicate_review = build(:review, user: user, movie: movie)

      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:user_id]).to include('has already reviewed this movie')
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'belongs to movie' do
      expect(described_class.reflect_on_association(:movie).macro).to eq(:belongs_to)
    end
  end
end
