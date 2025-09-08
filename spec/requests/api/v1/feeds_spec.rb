require 'rails_helper'

RSpec.describe 'Feeds', type: :request do
  describe 'GET /api/v1/feeds' do
    context 'when service returns error' do
      before do
        allow(FeedService).to receive(:index).with({ user_id: '123' }).and_return({ success: false, message: 'User not found', errors: {}, code: 400 })
      end

      it 'returns 400 status' do
        get '/api/v1/feeds', params: { user_id: '123' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(response_body['message']).to eq('User not found')
      end
    end

    context 'when service returns success' do
      before do
        allow(FeedService).to receive(:index).with({ user_id: '123' }).and_return({ success: true, message: 'Feeds fetched successfully', data: {}, code: 200 })
      end

      it 'returns 200 status' do
        get '/api/v1/feeds', params: { user_id: '123' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response_body['message']).to eq('Feeds fetched successfully')
      end
    end
  end
end
