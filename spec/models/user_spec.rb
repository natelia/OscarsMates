require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:year) { 2025 }

  it 'is valid with a name, email and password' do
    user = described_class.new(name: 'Admin', email: 'admin@example.com', password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = described_class.new(name: nil, email: 'admin@example.com', password: 'password')
    expect(user).not_to be_valid
  end

  it 'is invalid without an email' do
    user = described_class.new(name: 'Admin', email: nil, password: 'password')
    expect(user).not_to be_valid
  end

  describe '#reviews_for_year' do
    let(:movie1) { create(:movie) }
    let(:movie2) { create(:movie) }
    let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: year) }
    let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: year) }

    it 'returns only rated reviews' do
      rated_review = create(:review, user: user, movie: movie1, stars: 8)
      unrated_review = create(:review, user: user, movie: movie2, stars: nil)

      reviews = user.reviews_for_year(year)

      expect(reviews).to include(rated_review)
      expect(reviews).not_to include(unrated_review)
    end
  end

  describe '#watched_movies_count_for_year' do
    let(:movie1) { create(:movie) }
    let(:movie2) { create(:movie) }
    let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: year) }
    let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: year) }

    it 'counts only rated reviews' do
      create(:review, user: user, movie: movie1, stars: 8)
      create(:review, user: user, movie: movie2, stars: nil)

      count = user.watched_movies_count_for_year(year)

      expect(count).to eq(1)
    end
  end
end
