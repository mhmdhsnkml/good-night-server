class SleepRecordSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :clock_in, :clock_out, :duration_s

  attribute :created_at do
    object.created_at.iso8601
  end

  attribute :updated_at do
    object.updated_at.iso8601
  end
end
