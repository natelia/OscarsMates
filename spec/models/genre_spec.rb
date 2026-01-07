require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      genre = build(:genre)
      expect(genre).to be_valid
    end

    it 'is invalid without a name' do
      genre = build(:genre, name: nil)
      expect(genre).not_to be_valid
      expect(genre.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      create(:genre, name: 'Drama')
      duplicate = build(:genre, name: 'Drama')

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many characterizations' do
      expect(described_class.reflect_on_association(:characterizations).macro).to eq(:has_many)
    end

    it 'has many movies through characterizations' do
      expect(described_class.reflect_on_association(:movies).macro).to eq(:has_many)
    end
  end
end
