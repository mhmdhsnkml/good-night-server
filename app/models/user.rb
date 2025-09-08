class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy

  # All the people I follow (outgoing followings)
  has_many :follows, foreign_key: :follower_id
  has_many :followings, through: :follows, source: :followed

  # All the people who follow me (incoming followers)
  has_many :reverse_follows, class_name: 'Follow', foreign_key: :followed_id
  has_many :followers, through: :reverse_follows, source: :follower
end
