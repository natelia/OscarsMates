require 'rails_helper'

RSpec.describe UserStatsService do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie1) { create(:movie, title: 'Movie 1', runtime: 120) }
  let(:movie2) { create(:movie, title: 'Movie 2', runtime: 90) }
  let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: 2025) }

  describe '.call' do
    context 'when user has watched movies' do
      let!(:review1) { create(:review, user: user, movie: movie1, watched_on: Time.zone.today) }
      let!(:review2) { create(:review, user: user, movie: movie2, watched_on: Time.zone.today) }

      it 'returns user stats with total movies watched and minutes watched' do
        result = described_class.call(user: user, year: 2025)

        expect(result).to be_success
        expect(result.data[:user_stats][:total_movies_watched]).to eq(2)
        expect(result.data[:user_stats][:total_minutes_watched]).to eq(210)
      end
    end

    context 'when user has not watched any movies' do
      it 'returns zero for all user stats' do
        result = described_class.call(user: user, year: 2025)

        expect(result).to be_success
        expect(result.data[:user_stats][:total_movies_watched]).to eq(0)
        expect(result.data[:user_stats][:total_minutes_watched]).to eq(0)
      end
    end

    context 'with mates stats' do
      let(:mate) { create(:user, name: 'Mate') }
      let!(:follow) { create(:follow, follower: user, followed: mate) }
      let!(:mate_review) { create(:review, user: mate, movie: movie1, watched_on: Time.zone.today) }
      let!(:user_review) { create(:review, user: user, movie: movie2, watched_on: Time.zone.today) }

      it 'returns stats for user and their mates' do
        result = described_class.call(user: user, year: 2025)

        expect(result).to be_success
        names = result.data[:mates_stats].pluck(:name).uniq
        expect(names).to include(user.name, mate.name)
      end
    end

    context 'when user has no mates' do
      let(:lonely_user) { create(:user, name: 'Lonely') }

      it 'returns stats for just the user' do
        result = described_class.call(user: lonely_user, year: 2025)

        expect(result).to be_success
        expect(result.data[:mates_stats]).to be_an(Array)
      end
    end
  end
end
