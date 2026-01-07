require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      favorite = build(:favorite)
      expect(favorite).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to movie' do
      expect(described_class.reflect_on_association(:movie).macro).to eq(:belongs_to)
    end

    it 'belongs to user' do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end
end
