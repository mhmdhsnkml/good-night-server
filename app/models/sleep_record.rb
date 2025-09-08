class SleepRecord < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(clock_out: nil).limit(1) }
  scope :order_by_created_at, -> { order(created_at: :desc) }
  scope :order_by_duration, -> { order(duration_s: :desc) }
  scope :from_week_ago, -> { where(clock_in: 1.week.ago..) }
  scope :clock_out_not_nil, -> { where.not(clock_out: nil) }

  validates :clock_in, presence: true
  validate :only_one_active_record_per_user, on: :create

  private

  def only_one_active_record_per_user
    return if clock_out.present?

    if user.sleep_records.active.exists?
      errors.add(:base, 'User already has an active sleep record')
    end
  end
end
