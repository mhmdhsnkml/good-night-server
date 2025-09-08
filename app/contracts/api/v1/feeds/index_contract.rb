module Api
  module V1
    module Feeds
      class IndexContract < ApplicationContract
        params do
          required(:user_id).filled(:string)
          optional(:page).filled(:integer)
          optional(:per_page).filled(:integer)
        end

        rule(:user_id).validate(:uuid)
      end
    end
  end
end
