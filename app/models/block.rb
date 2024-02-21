# frozen_string_literal: true

# == Schema Information
#
# Table name: blocks
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  blocked_user_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Block < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :blocked_user, class_name: 'User'

  MSG = 'already blocked'

  # Validations
  validates :user_id, :blocked_user_id, presence: true
  ## unique constraint does the job but i need the message.
  validates :user_id, uniqueness: { scope: :blocked_user_id, message: MSG }
  ## User should not blocks (him/her)self
  validate :cannot_block_self

  def cannot_block_self
    errors.add(:base, 'You not block yourself') if user_id == blocked_user_id
  end
end
