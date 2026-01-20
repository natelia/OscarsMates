require 'rails_helper'

RSpec.describe UserMovieProgress do
  let(:user) { create(:user) }
  let(:movie1) { create(:movie, title: 'Avatar') }
  let(:movie2) { create(:movie, title: 'Star Trek') }
  let!(:review1) { create(:review, user: user, movie: movie1, stars: 6) }
  let!(:review2) { create(:review, user: user, movie: movie2, stars: 9) }

  describe '.call' do
    context 'when user is nil' do
      it 'returns empty hash' do
        result = described_class.call(movies: [movie1, movie2], user: nil)

        expect(result).to be_success
        expect(result.data).to eq({})
      end
    end

    context 'when user has reviews' do
      it 'returns hash of movie_id to review' do
        result = described_class.call(movies: [movie1, movie2], user: user)

        expect(result).to be_success
        expect(result.data).to be_a(Hash)
        expect(result.data.keys.size).to eq(2)
        expect(result.data).to have_key(movie1.id)
        expect(result.data[movie1.id].id).to eq(review1.id)
      end
    end
  end
end
