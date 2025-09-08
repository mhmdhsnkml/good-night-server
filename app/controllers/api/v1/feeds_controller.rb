module Api
  module V1
    class FeedsController < BaseController
      def index
        result = FeedService.index(api_params)
        handle_service_result(result)
      end
    end
  end
end
