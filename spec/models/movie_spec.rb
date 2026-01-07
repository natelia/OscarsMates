require 'rails_helper'

RSpec.describe Movie, type: :model do
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
end
