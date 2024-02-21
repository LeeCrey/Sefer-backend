# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  content          :text
#  user_id          :bigint           not null
#  cached_votes_up  :integer          default(0), not null
#  replies_count    :integer          default(0), not null
#  commentable_type :string           not null
#  commentable_id   :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  belongs_to :post_comment, -> { where(comments: { commentable_type: 'Post' }) },
             foreign_key: :commentable_id, optional: true

  counter_culture :commentable, touch: true
  acts_as_votable

  validates :content, presence: true
end
