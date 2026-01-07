require 'rails_helper'

RSpec.describe Nomination, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      nomination = build(:nomination)
      expect(nomination).to be_valid
    end

    it 'is invalid without a year' do
      nomination = build(:nomination, year: nil)
      expect(nomination).not_to be_valid
    end

    it 'is invalid with year before 1929' do
      nomination = build(:nomination, year: 1928)
      expect(nomination).not_to be_valid
    end

    it 'is invalid with year after 2100' do
      nomination = build(:nomination, year: 2101)
      expect(nomination).not_to be_valid
    end

    it 'is invalid with non-integer year' do
      nomination = build(:nomination, year: 2025.5)
      expect(nomination).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to movie' do
      expect(described_class.reflect_on_association(:movie).macro).to eq(:belongs_to)
    end

    it 'belongs to category' do
      expect(described_class.reflect_on_association(:category).macro).to eq(:belongs_to)
    end
  end

  describe '.available_years' do
    before do
      movie = create(:movie)
      category = create(:category)
      create(:nomination, movie: movie, category: category, year: 2025)
      create(:nomination, movie: movie, category: category, year: 2024)
      create(:nomination, movie: movie, category: category, year: 2023)
    end

    it 'returns distinct years in descending order' do
      result = Nomination.available_years

      expect(result).to eq([2025, 2024, 2023])
    end
  end
end
