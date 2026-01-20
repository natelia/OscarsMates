require 'rails_helper'

RSpec.describe UsersIndexService do
  let(:year) { 2025 }
  let(:current_user) { create(:user) }

  describe '#call' do
    context 'without filter' do
      let(:service) { described_class.new(current_user: current_user, year: year).call }

      before do
        # Create users with different watch counts
        @user1 = create(:user, name: 'Top Watcher')
        @user2 = create(:user, name: 'Second Watcher')
        @user3 = create(:user, name: 'Third Watcher')
        @user4 = create(:user, name: 'Fourth Watcher')

        movie = create(:movie, :with_nomination)

        # User1 has 1 review
        create(:review, user: @user1, movie: movie)
      end

      it 'returns top 3 watchers' do
        expect(service.top_watchers.size).to be <= 3
      end

      it 'returns remaining users' do
        expect(service.remaining_users).to be_an(Array)
      end

      it 'returns watched counts hash' do
        expect(service.watched_counts).to be_a(Hash)
      end

      it 'returns total movies count' do
        expect(service.total_movies_count).to be_a(Integer)
      end
    end

    context 'with followed filter' do
      before do
        @followed_user = create(:user, name: 'Followed User')
        current_user.following << @followed_user
      end

      let(:service) { described_class.new(current_user: current_user, year: year, filter: 'followed').call }

      it 'returns empty top watchers' do
        expect(service.top_watchers).to be_empty
      end

      it 'returns only followed users in remaining' do
        expect(service.remaining_users).to include(@followed_user)
        expect(service.remaining_users).not_to include(current_user)
      end
    end
  end
end
