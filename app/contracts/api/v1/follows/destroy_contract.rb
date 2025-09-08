module Api
  module V1
    module Follows
      class DestroyContract < ApplicationContract
        params do
          required(:followed_id).filled(:string)
          required(:follower_id).filled(:string)
        end

        rule(:followed_id).validate(:uuid)
        rule(:follower_id).validate(:uuid)
      end
    end
  end
end
