require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      review = build(:review, user: user, movie: movie)
      expect(review).to be_valid
    end

    it 'is valid without stars (unrated review)' do
      review = build(:review, user: user, movie: movie, stars: nil)
      expect(review).to be_valid
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
      expect(duplicate_review.errors[:base]).to include('You have already reviewed this movie')
    end
  end

  describe 'unrated reviews (null stars)' do
    it 'allows saving a review without stars' do
      review = create(:review, user: user, movie: movie, stars: nil, comment: 'Great movie!')
      expect(review).to be_persisted
      expect(review.stars).to be_nil
      expect(review.comment).to eq('Great movie!')
    end

    it 'preserves comment and date when stars are nil' do
      watched_date = 2.days.ago
      review = create(:review, user: user, movie: movie, stars: nil,
                               comment: 'My thoughts', watched_on: watched_date)

      expect(review.reload.stars).to be_nil
      expect(review.comment).to eq('My thoughts')
      expect(review.watched_on).to be_within(1.second).of(watched_date)
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
