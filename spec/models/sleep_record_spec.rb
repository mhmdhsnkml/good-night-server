require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:clock_in) }
end
