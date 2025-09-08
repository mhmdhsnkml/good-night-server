module Api
  module V1
    module Follows
      class CreateContract < ApplicationContract
        params do
          required(:follower_id).filled(:string)
          required(:followed_id).filled(:string)
        end

        rule(:follower_id).validate(:uuid)
        rule(:followed_id).validate(:uuid)
      end
    end
  end
end
