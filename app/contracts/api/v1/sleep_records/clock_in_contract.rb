module Api
  module V1
    module SleepRecords
      class ClockInContract < ApplicationContract
        params do
          required(:user_id).filled(:string)
        end

        rule(:user_id).validate(:uuid)
      end
    end
  end
end
