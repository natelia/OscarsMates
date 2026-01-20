require 'rails_helper'

RSpec.describe UserFilterService do
  let(:current_user) { create(:user) }
  let(:followed_user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:follow) { create(:follow, follower: current_user, followed: followed_user) }

  describe '.call' do
    context 'when filter is "followed" and user is logged in' do
      it 'returns only followed users' do
        result = described_class.call(current_user: current_user, filter: 'followed')

        expect(result).to be_success
        expect(result.data).to include(followed_user)
        expect(result.data).not_to include(other_user)
        expect(result.data).not_to include(current_user)
      end
    end

    context 'when filter is not "followed"' do
      it 'returns all users' do
        result = described_class.call(current_user: current_user, filter: 'all')

        expect(result).to be_success
        expect(result.data).to include(current_user, followed_user, other_user)
      end
    end

    context 'when current_user is nil' do
      it 'returns all users' do
        result = described_class.call(current_user: nil, filter: 'followed')

        expect(result).to be_success
        expect(result.data).to include(current_user, followed_user, other_user)
      end
    end
  end
end
