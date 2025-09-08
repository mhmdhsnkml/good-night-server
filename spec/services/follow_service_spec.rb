require 'rails_helper'

RSpec.describe FollowService do
  let(:follower) { create(:user, name: 'Ihsan Kamil') }
  let(:followed) { create(:user, name: 'John Doe') }

  describe '#create' do
    context 'when follower and followed not found' do
      it 'returns an error' do
        result = described_class.create({ follower_id: SecureRandom.uuid, followed_id: SecureRandom.uuid })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('Follower or followed not found')
      end
    end

    context 'when follower and followed are the same' do
      it 'returns an error' do
        result = described_class.create({ follower_id: follower.id, followed_id: follower.id })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('Follower and followed cannot be the same')
      end
    end

    context 'when already followed' do
      before do
        create(:follow, follower: follower, followed: followed)
      end

      it 'returns an error' do
        result = described_class.create({ follower_id: follower.id, followed_id: followed.id })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('Already followed')
      end
    end

    context 'when follower and followed found' do
      it 'returns a success' do
        result = described_class.create({ follower_id: follower.id, followed_id: followed.id })
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Followed successfully')
        expect(result[:data][:follower_id]).to eq(follower.id)
        expect(result[:data][:followed_id]).to eq(followed.id)
      end
    end
  end

  describe '#destroy' do
    context 'when follow not found' do
      it 'returns an error' do
        result = described_class.destroy({ follower_id: follower.id, followed_id: followed.id })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('Follow not found')
      end
    end
    
    context 'when already followed' do
      before do
        create(:follow, follower: follower, followed: followed)
      end

      it 'returns a success' do
        result = described_class.destroy({ follower_id: follower.id, followed_id: followed.id })
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Unfollowed successfully')
      end
    end
  end
end
