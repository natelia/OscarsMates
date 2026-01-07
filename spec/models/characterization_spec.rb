require 'rails_helper'

RSpec.describe Characterization, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      characterization = build(:characterization)
      expect(characterization).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to movie' do
      expect(described_class.reflect_on_association(:movie).macro).to eq(:belongs_to)
    end

    it 'belongs to genre' do
      expect(described_class.reflect_on_association(:genre).macro).to eq(:belongs_to)
    end
  end
end
