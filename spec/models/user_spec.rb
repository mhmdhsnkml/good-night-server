require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:sleep_records) }
  it { should have_many(:follows).with_foreign_key(:follower_id) }
  it { should have_many(:followings).through(:follows).source(:followed) }
  it { should have_many(:reverse_follows).class_name('Follow').with_foreign_key(:followed_id) }
  it { should have_many(:followers).through(:reverse_follows).source(:follower) }
end
