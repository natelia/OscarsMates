require 'rails_helper'

RSpec.describe UsersIndexService do
  let(:year) { 2025 }
  let(:current_user) { create(:user) }

  describe '.call' do
    context 'without filter' do
      let!(:user1) { create(:user, name: 'Top Watcher') }
      let!(:user2) { create(:user, name: 'Second Watcher') }
      let!(:user3) { create(:user, name: 'Third Watcher') }
      let!(:user4) { create(:user, name: 'Fourth Watcher') }
      let!(:movie) { create(:movie, :with_nomination) }
      let!(:review) { create(:review, user: user1, movie: movie) }

      it 'returns top 3 watchers' do
        result = described_class.call(current_user: current_user, year: year)

        expect(result).to be_success
        expect(result.data[:top_watchers].size).to be <= 3
      end

      it 'returns remaining users' do
        result = described_class.call(current_user: current_user, year: year)

        expect(result).to be_success
        expect(result.data[:remaining_users]).to be_an(Array)
      end

      it 'returns watched counts hash' do
        result = described_class.call(current_user: current_user, year: year)

        expect(result).to be_success
        expect(result.data[:watched_counts]).to be_a(Hash)
      end

      it 'returns total movies count' do
        result = described_class.call(current_user: current_user, year: year)

        expect(result).to be_success
        expect(result.data[:total_movies_count]).to be_a(Integer)
      end
    end

    context 'with followed filter' do
      let!(:followed_user) { create(:user, name: 'Followed User') }

      before do
        current_user.following << followed_user
      end

      it 'returns empty top watchers' do
        result = described_class.call(current_user: current_user, year: year, filter: 'followed')

        expect(result).to be_success
        expect(result.data[:top_watchers]).to be_empty
      end

      it 'returns only followed users in remaining' do
        result = described_class.call(current_user: current_user, year: year, filter: 'followed')

        expect(result).to be_success
        expect(result.data[:remaining_users]).to include(followed_user)
        expect(result.data[:remaining_users]).not_to include(current_user)
      end
    end
  end
end
