require 'rails_helper'

RSpec.describe UserFilterService do
  let(:current_user) { create(:user) }
  let(:followed_user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:follow) { create(:follow, follower: current_user, followed: followed_user) }

  describe '#call' do
    context 'when filter is "followed" and user is logged in' do
      it 'returns only followed users' do
        service = described_class.new(current_user, 'followed')

        result = service.call

        expect(result).to include(followed_user)
        expect(result).not_to include(other_user)
        expect(result).not_to include(current_user)
      end
    end

    context 'when filter is not "followed"' do
      it 'returns all users' do
        service = described_class.new(current_user, 'all')

        result = service.call

        expect(result).to include(current_user, followed_user, other_user)
      end
    end

    context 'when current_user is nil' do
      it 'returns all users' do
        service = described_class.new(nil, 'followed')

        result = service.call

        expect(result).to include(current_user, followed_user, other_user)
      end
    end
  end
end
