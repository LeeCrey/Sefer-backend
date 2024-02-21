# frozen_string_literal: true

# == Schema Information
#
# Table name: short_videos
#
#  id              :bigint           not null, primary key
#  user_id         :bigint           not null
#  caption         :string
#  cached_votes_up :integer          default(0), not null
#  comments_count  :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ShortVideo < ApplicationRecord
  belongs_to :user
  with_options dependent: :destroy do |assoc|
    assoc.has_one_attached :video
    assoc.has_many :comments, as: :commentable
  end
  acts_as_votable

  validates :video,
            content_type: %i[mp4 mp3],
            size: { less_than: 25.megabytes, message: 'is too large' }
end
