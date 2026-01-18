require 'rails_helper'

RSpec.describe MatesReviewsQuery do
  let(:user) { create(:user) }
  let(:mate1) { create(:user, name: 'Mate 1') }
  let(:mate2) { create(:user, name: 'Mate 2') }
  let(:non_mate) { create(:user, name: 'Non Mate') }
  let!(:follow1) { create(:follow, follower: user, followed: mate1) }
  let!(:follow2) { create(:follow, follower: user, followed: mate2) }

  let(:category) { create(:category) }
  let(:movie1) { create(:movie, title: 'Movie 1') }
  let(:movie2) { create(:movie, title: 'Movie 2') }
  let!(:nomination1) { create(:nomination, movie: movie1, category: category, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: movie2, category: category, year: 2025) }

  describe '#results' do
    context 'when mates have reviews' do
      let!(:mate1_review) { create(:review, user: mate1, movie: movie1, created_at: 1.day.ago) }
      let!(:mate2_review) { create(:review, user: mate2, movie: movie2, created_at: 2.days.ago) }

      it 'returns reviews from followed users' do
        query = described_class.new(user, 2025)

        result = query.results

        expect(result).to include(mate1_review, mate2_review)
      end

      it 'orders reviews by created_at descending' do
        query = described_class.new(user, 2025)

        result = query.results

        expect(result.first).to eq(mate1_review)
      end
    end

    context 'when non-mate has reviews' do
      let!(:non_mate_review) { create(:review, user: non_mate, movie: movie1) }

      it 'does not include reviews from non-mates' do
        query = described_class.new(user, 2025)

        result = query.results

        expect(result).not_to include(non_mate_review)
      end
    end

    context 'with limit parameter' do
      let!(:reviews) do
        Array.new(6) do |i|
          movie = create(:movie, title: "Movie #{i + 10}")
          create(:nomination, movie: movie, category: category, year: 2025)
          create(:review, user: mate1, movie: movie, created_at: i.days.ago)
        end
      end

      it 'respects the limit' do
        query = described_class.new(user, 2025, limit: 3)

        result = query.results

        expect(result.count).to eq(3)
      end

      it 'defaults to 5 reviews' do
        query = described_class.new(user, 2025)

        result = query.results

        expect(result.count).to eq(5)
      end
    end

    context 'when user has no mates' do
      let(:lonely_user) { create(:user) }

      it 'returns empty collection' do
        query = described_class.new(lonely_user, 2025)

        result = query.results

        expect(result).to be_empty
      end
    end
  end
end
