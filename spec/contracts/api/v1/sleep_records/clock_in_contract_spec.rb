require 'rails_helper'

RSpec.describe Api::V1::SleepRecords::ClockInContract do
  subject(:contract) { described_class.new }

  it 'fails when user_id is not present' do
    result = contract.call(user_id: nil)
    expect(result).to be_failure
  end

  it 'fails when user_id is not a uuid' do
    result = contract.call(user_id: '1')
    expect(result).to be_failure
  end

  it 'fails when user_id is empty' do
    result = contract.call(user_id: '')
    expect(result).to be_failure
  end

  it 'succeeds when user_id is present' do
    result = contract.call(user_id: SecureRandom.uuid)
    expect(result).to be_success
  end
end
