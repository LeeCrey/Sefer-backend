# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id              :bigint           not null, primary key
#  content         :text
#  community_id    :bigint
#  user_id         :bigint           not null
#  cached_votes_up :integer          default(0), not null
#  comments_count  :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :community, foreign_key: :community_id, optional: true

  with_options dependent: :destroy do |assoc|
    assoc.has_many_attached :photos
    assoc.has_many :comments, as: :commentable
  end
  acts_as_taggable_on :tags
  acts_as_votable

  scope :voted_by, lambda { |u_id|
    joins(:votes_for).select('posts.*, true as is_voted')
                     .where(votes: { voter_id: u_id }).order(id: :desc)
  }

  def self.following_users_post(u_id)
    includes(:tags, user: { profile_attachment: :blob })
      .joins(user: :followers)
      .joins("LEFT JOIN votes ON votes.votable_id = posts.id AND votes.votable_type = 'Post' AND votes.voter_id = #{u_id}")
      .select('posts.*, CASE WHEN votes.votable_id IS NOT NULL THEN true ELSE false END as is_voted')
      .where(follows: { follower_id: u_id }).where(community_id: nil)
      .order(id: :desc)
  end
end
