require 'rails_helper'

RSpec.describe Api::V1::Follows::CreateContract do
  subject(:contract) { described_class.new }

  it 'fails when follower_id is not present' do
    result = contract.call(follower_id: nil)
    expect(result).to be_failure
  end

  it 'fails when follower_id is not a string' do
    result = contract.call(follower_id: 1)
    expect(result).to be_failure
  end

  it 'fails when follower_id is not a valid UUID' do
    result = contract.call(follower_id: 'invalid-uuid')
    expect(result).to be_failure
  end

  it 'fails when followed_id is not present' do
    result = contract.call(followed_id: nil)
    expect(result).to be_failure
  end

  it 'fails when followed_id is not a string' do
    result = contract.call(followed_id: 1)
    expect(result).to be_failure
  end

  it 'fails when followed_id is not a valid UUID' do
    result = contract.call(followed_id: 'invalid-uuid')
    expect(result).to be_failure
  end

  it 'succeeds when follower_id and followed_id are present' do
    result = contract.call(follower_id: SecureRandom.uuid, followed_id: SecureRandom.uuid)
    expect(result).to be_success
  end
end
