require 'rails_helper'

RSpec.describe RankingService do
  let(:category) { create(:category) }
  let(:long_movie) { create(:movie, title: 'Long Movie', runtime: 180) }
  let(:short_movie) { create(:movie, title: 'Short Movie', runtime: 90) }
  let!(:long_nominations) { create_list(:nomination, 3, movie: long_movie, category: category, year: 2025) }
  let!(:short_nomination) { create(:nomination, movie: short_movie, category: category, year: 2025) }
  let!(:other_year_nomination) { create(:nomination, movie: short_movie, category: category, year: 2024) }

  let(:alice) { create(:user, name: 'Alice') }
  let(:bob) { create(:user, name: 'Bob') }
  let(:loner) { create(:user, name: 'Lonely') }
  let!(:all_users) { [alice, bob, loner] }

  before do
    # Alice watched both movies, Bob only the long one, lonely nobody
    create(:review, user: alice, movie: long_movie, stars: 8, watched_on: 2.days.ago)
    create(:review, user: alice, movie: short_movie, stars: 9, watched_on: 1.day.ago)
    create(:review, user: bob, movie: long_movie, stars: 7, watched_on: 3.days.ago)
  end

  describe '#ranked_users' do
    it 'ranks by watched films with goals percentages' do
      service = described_class.new(year: 2025, metric: :films, mode: :goals, scope: :all)

      ranked = service.ranked_users

      expect(ranked.pluck(:user)).to eq([alice, bob, loner])
      expect(ranked.first[:stats][:films]).to eq(watched: 2, total: 2, percentage: 100.0)
      expect(ranked.second[:stats][:films]).to eq(watched: 1, total: 2, percentage: 50.0)
      expect(ranked.third[:stats][:films]).to eq(watched: 0, total: 2, percentage: 0.0)
    end

    it 'ranks by minutes' do
      service = described_class.new(year: 2025, metric: :minutes, mode: :goals, scope: :all)

      ranked = service.ranked_users

      expect(ranked.first[:stats][:minutes][:watched]).to eq(270)
      expect(ranked.second[:stats][:minutes][:watched]).to eq(180)
    end

    it 'counts nominations per watched movie' do
      service = described_class.new(year: 2025, metric: :nominations, mode: :goals, scope: :all)

      ranked = service.ranked_users

      expect(ranked.first[:stats][:nominations][:watched]).to eq(4)
      expect(ranked.second[:stats][:nominations][:watched]).to eq(3)
    end

    it 'uses the best user as the denominator in totals mode' do
      service = described_class.new(year: 2025, metric: :films, mode: :totals, scope: :all)

      ranked = service.ranked_users

      expect(ranked.first[:stats][:films][:percentage]).to eq(100.0)
      expect(ranked.second[:stats][:films]).to eq(watched: 1, total: 2, percentage: 50.0)
    end

    it 'ignores unrated reviews' do
      create(:review, user: loner, movie: long_movie, stars: nil, watched_on: Time.current)

      service = described_class.new(year: 2025, metric: :films, scope: :all)

      expect(service.ranked_users.third[:stats][:films][:watched]).to eq(0)
    end

    it 'counts a movie once when a user reviewed it in both scopes' do
      service = described_class.new(year: 2025, metric: :films, scope: :all)

      expect(service.ranked_users.first[:stats][:films][:watched]).to eq(2)
    end

    it 'limits to the current user and their mates in mates scope' do
      create(:follow, follower: loner, followed: alice)

      service = described_class.new(year: 2025, current_user: loner, metric: :films, scope: :mates)

      expect(service.ranked_users.pluck(:user)).to contain_exactly(alice, loner)
    end
  end

  describe '#totals' do
    it 'returns the available totals for the year' do
      service = described_class.new(year: 2025)

      expect(service.totals).to eq(films: 2, minutes: 270, nominations: 4)
    end
  end
end
