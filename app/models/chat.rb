# frozen_string_literal: true

# == Schema Information
#
# Table name: chats
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  receiver_id   :bigint
#  chat_type     :integer          default("group_chat"), not null
#  members_count :integer          default(0), not null
#  name          :string
#  description   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id, optional: true
  has_one_attached :cover
  has_many :blocked_users, as: :blocker, dependent: :destroy

  enum chat_type: { private_chat: 0, group_chat: 1 }

  # Validations
  validates :name, presence: true, if: -> { group_chat? }
  validates :description, :name, absence: true, if: -> { private_chat? }
  validates :receiver_id, presence: true, if: -> { private_chat? }
  validates :cover, processable_image: true,
                    content_type: %i[png jpg jpeg],
                    size: { less_than: 1.megabytes, message: 'is too large' },
                    if: -> { cover.attached? }

  scope :user_chats, lambda { |u_id|
    where(user_id: u_id).order(where(receiver_id: u_id))
  }
end
