# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id          :bigint           not null, primary key
#  follower_id :bigint           not null
#  followed_id :bigint           not null
#  approved    :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  MSG = 'already following user'

  # Validations
  validates :follower_id, :followed_id, presence: true
  ## unique constraint does the job but i need the message.
  validates :follower_id, uniqueness: { scope: :followed_id, message: MSG }
  ## User should not follow (him/her)self
  validate :cannot_follow_self

  def cannot_follow_self
    errors.add(:base, 'You cannot follow yourself') if follower_id == followed_id
  end
end
