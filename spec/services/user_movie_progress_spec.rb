require 'rails_helper'

RSpec.describe UserMovieProgress do
  let(:user) { create(:user) }
  let(:movie1) { create(:movie, title: 'Avatar') }
  let(:movie2) { create(:movie, title: 'Star Trek') }
  let!(:review1) { create(:review, user: user, movie: movie1, stars: 6) }
  let!(:review2) { create(:review, user: user, movie: movie2, stars: 9) }

  describe '#call' do
    context 'when user is nil' do
      it 'returns empty hash' do
        result = described_class.new([movie1, movie2], nil).call
        expect(result).to eq({})
      end
    end

    context 'when user has reviews' do
      it 'returns hash of movie_id to review' do
        result = described_class.new([movie1, movie2], user).call

        expect(result).to be_a(Hash)
        expect(result.keys.size).to eq(2)
        expect(result).to have_key(movie1.id)
        expect(result[movie1.id].id).to eq(review1.id)
      end
    end
  end
end
