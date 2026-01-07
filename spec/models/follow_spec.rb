require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      follow = build(:follow, follower: follower, followed: followed)
      expect(follow).to be_valid
    end

    it 'is invalid if already following the user' do
      create(:follow, follower: follower, followed: followed)
      duplicate = build(:follow, follower: follower, followed: followed)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:follower_id]).to include('You are already following this user.')
    end

    it 'allows following different users' do
      another_user = create(:user)
      create(:follow, follower: follower, followed: followed)
      new_follow = build(:follow, follower: follower, followed: another_user)

      expect(new_follow).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to follower' do
      expect(described_class.reflect_on_association(:follower).macro).to eq(:belongs_to)
    end

    it 'belongs to followed' do
      expect(described_class.reflect_on_association(:followed).macro).to eq(:belongs_to)
    end
  end
end
