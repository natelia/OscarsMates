require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie) { create(:movie) }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      review = build(:review, user: user, movie: movie, year: 2025)
      expect(review).to be_valid
    end

    it 'is invalid without stars' do
      review = build(:review, user: user, movie: movie, year: 2025, stars: nil)
      expect(review).not_to be_valid
    end

    it 'is invalid with stars less than 1' do
      review = build(:review, user: user, movie: movie, year: 2025, stars: 0)
      expect(review).not_to be_valid
      expect(review.errors[:stars]).to include('must be between 1 and 10')
    end

    it 'is invalid with stars greater than 10' do
      review = build(:review, user: user, movie: movie, year: 2025, stars: 11)
      expect(review).not_to be_valid
      expect(review.errors[:stars]).to include('must be between 1 and 10')
    end

    it 'is invalid without watched_on' do
      review = build(:review, user: user, movie: movie, year: 2025, watched_on: nil)
      expect(review).not_to be_valid
      expect(review.errors[:watched_on]).to include("can't be blank")
    end

    it 'is invalid if user has already reviewed the movie for the same year' do
      create(:review, user: user, movie: movie, year: 2025)
      duplicate_review = build(:review, user: user, movie: movie, year: 2025)

      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:base]).to include('You have already reviewed this movie for this year')
    end

    it 'is invalid if movie is not nominated in year' do
      review = build(:review, user: user, movie: movie, year: 2024)
      expect(review).not_to be_valid
      expect(review.errors[:movie]).to include('is not nominated in 2024')
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
