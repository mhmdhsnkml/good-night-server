require 'rails_helper'

RSpec.describe SleepRecordService do
  let(:user) { create(:user, name: 'Ihsan Kamil') }

  describe '#clock_in' do
    context 'when the user not found' do
      it 'returns an error' do
        result = described_class.clock_in({ user_id: SecureRandom.uuid })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('User not found')
      end
    end

    context 'when the user already clocked in' do
      before do
        create(:sleep_record, user: user, clock_in: Time.now, clock_out: nil)
      end

      it 'returns an error' do
        result = described_class.clock_in({ user_id: user.id })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('User already has an active sleep record')
      end
    end
    
    context 'when the user not already clocked in' do
      it 'returns a success' do
        result = described_class.clock_in({ user_id: user.id })
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Clock in successfully')
        expect(result[:data][:sleep_record]).to be_present
        expect(result[:data][:user_sleep_records].count).to eq(1)
      end
    end

    context 'when the user already exists and have 1 sleep record' do
      before do
        clock_in = Time.now.yesterday
        clock_out = clock_in + 1.hour
        duration = clock_out - clock_in
        create(:sleep_record, user: user, clock_in: clock_in, clock_out: clock_out, duration_s: duration)
      end

      it 'returns a success' do
        result = described_class.clock_in({ user_id: user.id })
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Clock in successfully')
        expect(result[:data][:sleep_record]).to be_present
        expect(result[:data][:user_sleep_records].count).to eq(2)
      end
    end
  end

  describe '#clock_out' do
    context 'when user not found' do
      it 'returns an error' do
        result = described_class.clock_out({ user_id: SecureRandom.uuid })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('User not found')
      end
    end

    context 'when user not clocked in' do
      it 'returns an error' do
        result = described_class.clock_out({ user_id: user.id })
        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('User not clocked in')
      end
    end
    
    context 'when user already clocked in' do
      before do
        create(:sleep_record, user: user, clock_in: Time.now, clock_out: nil)
      end

      it 'returns a success' do
        result = described_class.clock_out({ user_id: user.id })
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Clock out successfully')
        expect(result[:data][:sleep_record]).to be_present
        expect(result[:data][:user_sleep_records].count).to eq(1)
        expect(result[:data][:sleep_record][:clock_out]).to be_present
        expect(result[:data][:sleep_record][:duration_s]).to be_present
      end
    end

    context 'when user already clocked in and have 1 sleep record' do
      before do
        clock_in = Time.now.yesterday
        clock_out = clock_in + 1.hour
        duration = clock_out - clock_in
        create(:sleep_record, user: user, clock_in: clock_in, clock_out: clock_out, duration_s: duration)
        create(:sleep_record, user: user, clock_in: Time.now - 1.hour, clock_out: nil)
      end

      it 'returns a success' do
        result = described_class.clock_out({ user_id: user.id })
        expect(result[:success]).to be_truthy
        expect(result[:message]).to eq('Clock out successfully')
        expect(result[:data][:sleep_record]).to be_present
        expect(result[:data][:user_sleep_records].count).to eq(2)
        expect(result[:data][:sleep_record][:clock_out]).to be_present
        expect(result[:data][:sleep_record][:duration_s]).to be_present
      end
    end
  end
end
