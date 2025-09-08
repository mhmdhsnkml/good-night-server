require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  describe 'POST /api/v1/follows' do
    context 'when service returns error' do
      before do
        allow(FollowService).to receive(:create).with({ follower_id: '123', followed_id: '456' }).and_return({ success: false, message: 'Follower or followed not found', errors: {}, code: 400 })
      end

      it 'returns 400 status' do
        post '/api/v1/follows', params: { follower_id: '123', followed_id: '456' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(response_body['message']).to eq('Follower or followed not found')
      end
    end

    context 'when service returns success' do
      before do
        allow(FollowService).to receive(:create).with({ follower_id: '123', followed_id: '456' }).and_return({ success: true, message: 'Followed successfully', data: {}, code: 200 })
      end

      it 'returns 200 status' do
        post '/api/v1/follows', params: { follower_id: '123', followed_id: '456' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response_body['message']).to eq('Followed successfully')
      end
    end
  end

  describe 'DELETE /api/v1/follows/:id' do
    context 'when service returns error' do
      before do
        allow(FollowService).to receive(:destroy).with({ id: '123', follower_id: '456' }).and_return({ success: false, message: 'Follow not found', errors: {}, code: 400 })
      end

      it 'returns 400 status' do
        delete '/api/v1/follows/123', params: { follower_id: '456' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(response_body['message']).to eq('Follow not found')
      end
    end

    context 'when service returns success' do
      before do
        allow(FollowService).to receive(:destroy).with({ id: '123', follower_id: '456' }).and_return({ success: true, message: 'Unfollowed successfully', data: {}, code: 200 })
      end

      it 'returns 200 status' do
        delete '/api/v1/follows/123', params: { follower_id: '456' }
        
        response_body = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response_body['message']).to eq('Unfollowed successfully')
      end
    end
  end
end