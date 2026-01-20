require 'rails_helper'

RSpec.describe UserProgressService do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie1) { create(:movie, title: 'Movie 1') }
  let(:movie2) { create(:movie, title: 'Movie 2') }
  let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: 2025) }

  describe '.call' do
    context 'when user has watched some movies' do
      let!(:review) { create(:review, user: user, movie: movie1) }

      it 'returns the percentage of movies watched' do
        result = described_class.call(user: user, year: 2025)

        expect(result).to be_success
        expect(result.data).to eq(50.0)
      end
    end

    context 'when user has watched all movies' do
      let!(:review1) { create(:review, user: user, movie: movie1) }
      let!(:review2) { create(:review, user: user, movie: movie2) }

      it 'returns 100 percent' do
        result = described_class.call(user: user, year: 2025)

        expect(result).to be_success
        expect(result.data).to eq(100.0)
      end
    end

    context 'when user has not watched any movies' do
      it 'returns 0 percent' do
        result = described_class.call(user: user, year: 2025)

        expect(result).to be_success
        expect(result.data).to eq(0.0)
      end
    end

    context 'when there are no movies for the year' do
      it 'returns 0 to avoid division by zero' do
        result = described_class.call(user: user, year: 2020)

        expect(result).to be_success
        expect(result.data).to eq(0)
      end
    end
  end
end
