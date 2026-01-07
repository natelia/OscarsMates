require 'rails_helper'

RSpec.describe ListCategoryQuery do
  let(:category1) { create(:category, name: 'Best Picture') }
  let(:category2) { create(:category, name: 'Best Director') }
  let(:category3) { create(:category, name: 'Best Actor') }
  let(:movie) { create(:movie) }
  let!(:nomination1) { create(:nomination, movie: movie, category: category1, year: 2025) }
  let!(:nomination2) { create(:nomination, movie: movie, category: category2, year: 2025) }
  let!(:nomination3) { create(:nomination, movie: movie, category: category3, year: 2024) }

  describe '#results' do
    context 'without search query' do
      it 'returns all categories for the year' do
        query = described_class.new({}, 2025)

        result = query.results

        expect(result).to include(category1, category2)
        expect(result).not_to include(category3)
      end
    end

    context 'with search query' do
      it 'returns categories matching the query for the year' do
        query = described_class.new({ query: 'Picture' }, 2025)

        result = query.results

        expect(result).to include(category1)
        expect(result).not_to include(category2)
      end

      it 'is case insensitive' do
        query = described_class.new({ query: 'director' }, 2025)

        result = query.results

        expect(result).to include(category2)
      end
    end

    context 'when no categories match' do
      it 'returns empty collection' do
        query = described_class.new({ query: 'Nonexistent' }, 2025)

        result = query.results

        expect(result).to be_empty
      end
    end
  end
end
