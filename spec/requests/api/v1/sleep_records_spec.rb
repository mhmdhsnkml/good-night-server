require 'rails_helper'

RSpec.describe 'SleepRecords', type: :request do
  describe 'POST /api/v1/sleep_records/clock_in' do
    context 'when service returns error' do
      before do
        allow(SleepRecordService).to receive(:clock_in).with({ name: 'Ihsan Kamil' }).and_return({ success: false, message: 'User already clocked in', errors: {}, code: 400 })
      end

      it 'returns 400 status' do
        post '/api/v1/sleep_records/clock_in', params: { name: 'Ihsan Kamil' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(response_body['message']).to eq('User already clocked in')
      end
    end

    context 'when service returns success' do
      before do
        allow(SleepRecordService).to receive(:clock_in).with({ name: 'Ihsan Kamil' }).and_return({ success: true, message: 'Clock in successfully', data: {}, code: 200 })
      end
      
      it 'returns 200 status' do
        post '/api/v1/sleep_records/clock_in', params: { name: 'Ihsan Kamil' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response_body['message']).to eq('Clock in successfully')
      end
    end
  end

  describe 'POST /api/v1/sleep_records/clock_out' do
    context 'when service returns error' do
      before do
        allow(SleepRecordService).to receive(:clock_out).with({ name: 'Ihsan Kamil' }).and_return({ success: false, message: 'User not found', errors: {}, code: 400 })
      end

      it 'returns 400 status' do
        post '/api/v1/sleep_records/clock_out', params: { name: 'Ihsan Kamil' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(response_body['message']).to eq('User not found')
      end
    end

    context 'when service returns success' do
      before do
        allow(SleepRecordService).to receive(:clock_out).with({ name: 'Ihsan Kamil' }).and_return({ success: true, message: 'Clock out successfully', data: {}, code: 200 })
      end

      it 'returns 200 status' do
        post '/api/v1/sleep_records/clock_out', params: { name: 'Ihsan Kamil' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response_body['message']).to eq('Clock out successfully')
      end
    end
  end
end
