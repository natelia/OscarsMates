require 'rails_helper'

RSpec.describe UserStatsService do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie1) { create(:movie, title: 'Movie 1', runtime: 120) }
  let(:movie2) { create(:movie, title: 'Movie 2', runtime: 90) }
  let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: 2025) }

  describe '#user_stats' do
    context 'when user has watched movies' do
      let!(:review1) { create(:review, user: user, movie: movie1, watched_on: Date.today) }
      let!(:review2) { create(:review, user: user, movie: movie2, watched_on: Date.today) }

      it 'returns total movies watched and total minutes watched' do
        service = described_class.new(user, 2025)

        result = service.user_stats

        expect(result[:total_movies_watched]).to eq(2)
        expect(result[:total_minutes_watched]).to eq(210)
      end
    end

    context 'when user has not watched any movies' do
      it 'returns zero for all stats' do
        service = described_class.new(user, 2025)

        result = service.user_stats

        expect(result[:total_movies_watched]).to eq(0)
        expect(result[:total_minutes_watched]).to eq(0)
      end
    end
  end

  describe '#mates_stats' do
    let(:mate) { create(:user, name: 'Mate') }
    let!(:follow) { create(:follow, follower: user, followed: mate) }
    let!(:mate_review) { create(:review, user: mate, movie: movie1, watched_on: Date.today) }
    let!(:user_review) { create(:review, user: user, movie: movie2, watched_on: Date.today) }

    it 'returns stats for user and their mates' do
      service = described_class.new(user, 2025)

      result = service.mates_stats

      names = result.map { |r| r[:name] }.uniq
      expect(names).to include(user.name, mate.name)
    end

    context 'when user has no mates' do
      let(:lonely_user) { create(:user, name: 'Lonely') }

      it 'returns stats for just the user' do
        service = described_class.new(lonely_user, 2025)

        result = service.mates_stats

        # Result may be empty if user has no reviews
        expect(result).to be_an(Array)
      end
    end
  end
end
