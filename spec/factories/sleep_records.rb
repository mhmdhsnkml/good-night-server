FactoryBot.define do
  factory :sleep_record do
    user { nil }
    clock_in { "2025-05-05 20:59:09" }
    clock_out { "2025-05-05 20:59:09" }
  end
end
