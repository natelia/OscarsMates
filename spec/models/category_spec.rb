require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      category = build(:category)
      expect(category).to be_valid
    end

    it 'is invalid without a name' do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many nominations' do
      expect(described_class.reflect_on_association(:nominations).macro).to eq(:has_many)
    end

    it 'has many movies through nominations' do
      expect(described_class.reflect_on_association(:movies).macro).to eq(:has_many)
    end
  end

  describe 'scopes' do
    let(:category1) { create(:category) }
    let(:category2) { create(:category) }
    let(:movie) { create(:movie) }

    before do
      create(:nomination, movie: movie, category: category1, year: 2025)
      create(:nomination, movie: movie, category: category2, year: 2024)
    end

    describe '.for_year' do
      it 'returns categories with nominations in the given year' do
        result = described_class.for_year(2025)

        expect(result).to include(category1)
        expect(result).not_to include(category2)
      end
    end
  end
end
