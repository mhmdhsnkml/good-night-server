class FeedService < ApplicationService
  class << self
    def index(params)
      validation = validate_with_contract(Api::V1::Feeds::IndexContract, params)
      return validation unless validation[:success]

      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 10 if params[:per_page].blank?

      user = User.find_by(id: params[:user_id])
      return error_response('User not found', {}, 400) if user.nil?

      user_ids = user.followings.pluck(:followed_id)
      user_ids << user.id

      sleep_records = SleepRecord.where(user_id: user_ids).clock_out_not_nil.from_week_ago.order_by_duration.page(params[:page]).per(params[:per_page])

      success_response('Feeds fetched successfully', {
        sleep_records: sleep_records,
        meta: {
          total_pages: sleep_records.total_pages,
          total_count: sleep_records.total_count,
          current_page: sleep_records.current_page,
          per_page: params[:per_page]
        }
      })
    end
  end
end
