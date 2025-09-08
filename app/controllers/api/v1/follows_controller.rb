module Api
  module V1
    class FollowsController < BaseController
      def create
        result = FollowService.create(api_params)
        handle_service_result(result)
      end
    
      def destroy
        result = FollowService.destroy(api_params)
        handle_service_result(result)
      end
    end
  end
end
