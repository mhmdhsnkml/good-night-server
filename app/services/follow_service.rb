class FollowService < ApplicationService
  class << self
    def create(params)
      validation = validate_with_contract(Api::V1::Follows::CreateContract, params)
      return validation unless validation[:success]
      return error_response('Follower and followed cannot be the same', {}, 400) if params[:follower_id] == params[:followed_id]

      follower = User.find_by(id: params[:follower_id])
      followed = User.find_by(id: params[:followed_id])
      return error_response('Follower or followed not found', {}, 400) if follower.nil? || followed.nil?
      return error_response('Already followed', {}, 400) if is_followed?(follower, followed)

      follow = Follow.create(follower_id: follower.id, followed_id: followed.id)
      return error_response('Failed to follow', {}, 400) if follow.errors.any?

      success_response('Followed successfully', follow)
    end

    def destroy(params)
      validation = validate_with_contract(Api::V1::Follows::DestroyContract, params)
      return validation unless validation[:success]

      follow = Follow.find_by(followed_id: params[:followed_id], follower_id: params[:follower_id])
      return error_response('Follow not found', {}, 400) if follow.nil?

      follow.destroy
      return error_response('Failed to unfollow', {}, 400) if follow.errors.any?

      success_response('Unfollowed successfully', {})
    end

    private

    def is_followed?(follower, followed)
      Follow.exists?(follower_id: follower.id, followed_id: followed.id)
    end
  end
end
