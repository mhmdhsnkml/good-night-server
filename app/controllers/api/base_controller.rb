module Api
  class BaseController < ApplicationController
    def api_params
      params.except(:controller, :action).to_unsafe_h
    end

    def handle_service_result(result)
      if result[:success]
        render json: { message: result[:message], data: result[:data] }, status: result[:code]
      else
        render json: { message: result[:message], errors: result[:errors] }, status: result[:code]
      end
    end
  end
end
