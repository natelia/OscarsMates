require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }

  describe 'validations' do
    it 'is invalid if rating is below 0' do
      movie = build(:movie, rating: -3)
      expect(movie).not_to be_valid
      expect(movie.errors[:rating]).to include('must be greater than or equal to 0')
    end

    it 'is invalid if rating is above 10' do
      movie = build(:movie, rating: 13)
      expect(movie).not_to be_valid
      expect(movie.errors[:rating]).to include('must be less than or equal to 10')
    end

    it 'is invalid if title is not unique' do
      movie = create(:movie)
      duplicate = build(:movie, title: movie.title)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:title]).to include('has already been taken')
    end

    it 'is invalid if runtime is not an integer' do
      movie = build(:movie, runtime: 121.123)
      expect(movie).not_to be_valid
      expect(movie.errors[:runtime]).to include('must be an integer')
    end

    %i[title english_title where_to_watch runtime rating url picture_url].each do |attr|
      it "is invalid without #{attr}" do
        movie = build(:movie)
        movie[attr] = nil
        expect(movie).not_to be_valid
        expect(movie.errors[attr]).to include("can't be blank")
      end
    end
  end

  describe '#average_stars' do
    it 'calculates average from rated reviews only' do
      create(:review, movie: movie, stars: 8)
      create(:review, movie: movie, stars: 6)
      create(:review, movie: movie, stars: nil) # Unrated - should be excluded

      expect(movie.average_stars).to eq(7.0)
    end

    it 'returns 0.0 when all reviews are unrated' do
      create(:review, movie: movie, stars: nil)
      create(:review, movie: movie, stars: nil)

      expect(movie.average_stars).to eq(0.0)
    end

    it 'returns 0.0 when there are no reviews' do
      expect(movie.average_stars).to eq(0.0)
    end
  end

  describe '#mates_average_stars' do
    let(:mate1) { create(:user) }
    let(:mate2) { create(:user) }

    before do
      Follow.create!(follower: user, followed: mate1)
      Follow.create!(follower: user, followed: mate2)
    end

    it 'calculates average from rated mate reviews only' do
      movie2 = create(:movie)
      create(:review, user: mate1, movie: movie, stars: 9)
      create(:review, user: mate2, movie: movie2, stars: 7)
      create(:review, user: create(:user), movie: movie, stars: 5) # Not a mate
      create(:review, user: mate1, movie: movie2, stars: nil) # Unrated - excluded

      expect(movie.mates_average_stars(user)).to eq(9.0)
    end

    it 'returns 0.0 when mates have only unrated reviews' do
      create(:review, user: mate1, movie: movie, stars: nil)

      expect(movie.mates_average_stars(user)).to eq(0.0)
    end
  end
end
