class SleepRecordService < ApplicationService
  class << self
    def clock_in(params)
      validation = validate_with_contract(Api::V1::SleepRecords::ClockInContract, params)
      return validation unless validation[:success]

      user = User.find_by(id: params[:user_id])
      return error_response('User not found', {}, 400) if user.nil?

      sleep_record = SleepRecord.create(user: user, clock_in: Time.now)
      return error_response('User already has an active sleep record', {}, 400) if sleep_record.errors.any?

      user_sleep_records = user.sleep_records.order_by_created_at.limit(10)

      success_response('Clock in successfully', {
        sleep_record: SleepRecordSerializer.new(sleep_record).as_json,
        user_sleep_records: ActiveModelSerializers::SerializableResource.new(user_sleep_records).as_json
      })
    end

    def clock_out(params)
      validation = validate_with_contract(Api::V1::SleepRecords::ClockOutContract, params)
      return validation unless validation[:success]

      current_time = Time.now
      user = User.find_by(id: params[:user_id])
      return error_response('User not found', {}, 400) if user.nil?

      sleep_record = user.sleep_records.active.first
      return error_response('User not clocked in', {}, 400) if sleep_record.nil?

      sleep_record.update(clock_out: current_time, duration_s: current_time - sleep_record.clock_in)
      return error_response('Failed to clock out', {}, 400) if sleep_record.errors.any?

      user_sleep_records = user.sleep_records.order_by_created_at.limit(10)

      success_response('Clock out successfully', {
        sleep_record: SleepRecordSerializer.new(sleep_record).as_json,
        user_sleep_records: ActiveModelSerializers::SerializableResource.new(user_sleep_records).as_json
      })
    end
  end
end
