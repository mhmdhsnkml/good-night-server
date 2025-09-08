require 'rails_helper'

RSpec.describe FeedService do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  def create_follow(follower, followed)
    create(:follow, follower: follower, followed: followed)
  end

  def create_sleep_record(user, duration, clock_in, clock_out)
    create(:sleep_record, user: user, duration_s: duration, clock_in: clock_in, clock_out: clock_out)
  end

  before do
    create_follow(user, user2)
    create_follow(user, user3)
    create_follow(user2, user3)

    create_sleep_record(user, 100, 6.days.ago, 6.days.ago + 100.minutes)
    create_sleep_record(user, 200, 5.days.ago, 5.days.ago + 200.minutes)

    create_sleep_record(user2, 200, 6.days.ago, 6.days.ago + 200.minutes)
    create_sleep_record(user2, 300, 5.days.ago, 5.days.ago + 300.minutes)

    create_sleep_record(user3, 300, 6.days.ago, 1.days.ago + 300.minutes)
    create_sleep_record(user3, 400, 5.days.ago, 6.days.ago + 400.minutes)
    create_sleep_record(user3, 500, 10.days.ago, 10.days.ago + 500.minutes)
  end

  describe '#call' do
    context 'when user not found' do
      it 'returns an error' do
        result = described_class.index({ user_id: SecureRandom.uuid })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('User not found')
      end
    end

    context 'when user found' do
      it 'returns a list of sleep records' do
        result = described_class.index({ user_id: user.id })
        expect(result[:success]).to be_truthy
        expect(result[:data][:sleep_records].count).to eq(6)
        expect(result[:data][:meta][:total_pages]).to eq(1)
        expect(result[:data][:meta][:total_count]).to eq(6)
        expect(result[:data][:meta][:current_page]).to eq(1)
        expect(result[:data][:meta][:per_page]).to eq(10)

        result = described_class.index({ user_id: user2.id })
        expect(result[:success]).to be_truthy
        expect(result[:data][:sleep_records].count).to eq(4)
        expect(result[:data][:meta][:total_pages]).to eq(1)
        expect(result[:data][:meta][:total_count]).to eq(4)
        expect(result[:data][:meta][:current_page]).to eq(1)
        expect(result[:data][:meta][:per_page]).to eq(10)

        result = described_class.index({ user_id: user3.id })
        expect(result[:success]).to be_truthy
        expect(result[:data][:sleep_records].count).to eq(2)
        expect(result[:data][:meta][:total_pages]).to eq(1)
        expect(result[:data][:meta][:total_count]).to eq(2)
        expect(result[:data][:meta][:current_page]).to eq(1)
        expect(result[:data][:meta][:per_page]).to eq(10)

        result = described_class.index({ user_id: user.id, page: 2, per_page: 2 })
        expect(result[:success]).to be_truthy
        expect(result[:data][:sleep_records].count).to eq(2)
        expect(result[:data][:meta][:total_pages]).to eq(3)
        expect(result[:data][:meta][:total_count]).to eq(6)
        expect(result[:data][:meta][:current_page]).to eq(2)
        expect(result[:data][:meta][:per_page]).to eq(2)
      end
    end
  end
end
