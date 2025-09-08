require 'rails_helper'

RSpec.describe Api::V1::Feeds::IndexContract do
  subject(:contract) { described_class.new }

  it 'fails when user_id is not present' do
    result = contract.call(user_id: nil)
    expect(result).to be_failure
  end
  
  it 'fails when user_id is not a string' do
    result = contract.call(user_id: 1)
    expect(result).to be_failure
  end

  it 'fails when user_id is not a valid UUID' do
    result = contract.call(user_id: 'invalid-uuid')
    expect(result).to be_failure
  end

  it 'fails when page is not a integer' do
    result = contract.call(user_id: SecureRandom.uuid, page: 'a')
    expect(result).to be_failure
  end

  it 'fails when per_page is not a integer' do
    result = contract.call(user_id: SecureRandom.uuid, per_page: 'b')
    expect(result).to be_failure
  end

  it 'succeeds when user_id is present' do
    result = contract.call(user_id: SecureRandom.uuid)
    expect(result).to be_success
  end

  it 'succeeds when page is present' do
    result = contract.call(user_id: SecureRandom.uuid, page: 1)
    expect(result).to be_success
  end

  it 'succeeds when per_page is present' do
    result = contract.call(user_id: SecureRandom.uuid, per_page: 10)
    expect(result).to be_success
  end

  it 'succeeds when page and per_page are present' do
    result = contract.call(user_id: SecureRandom.uuid, page: 1, per_page: 10)
    expect(result).to be_success
  end
end
