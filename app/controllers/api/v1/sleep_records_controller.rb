module Api
  module V1
    class SleepRecordsController < BaseController
      def clock_in
        result = SleepRecordService.clock_in(api_params)
        handle_service_result(result)
      end
    
      def clock_out
        result = SleepRecordService.clock_out(api_params)
        handle_service_result(result)
      end
    end
  end
end
