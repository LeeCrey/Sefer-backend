# frozen_string_literal: true

# == Schema Information
#
# Table name: communities
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  description    :string
#  community_type :integer          default("Public"), not null
#  user_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  members_count  :integer          default(0), not null
#
class Community < ApplicationRecord
  belongs_to :user
  with_options dependent: :destroy do |assoc|
    assoc.has_one_attached :profile
    assoc.has_many :posts, foreign_key: :community_id
    assoc.has_many :members
  end
  has_many :users, through: :members

  enum community_type: { Public: 0, Private: 1 }

  def posts_with_status(u_id)
    posts.includes(:tags, user: { profile_attachment: :blob })
         .joins("LEFT JOIN votes ON votes.votable_id = posts.id AND votes.votable_type = 'Post' AND votes.voter_id = #{u_id}")
         .select('posts.*, CASE WHEN votes.votable_id IS NOT NULL THEN true ELSE false END as is_voted')
         .order(id: :desc)
  end

  def members_with_status(u_id)
    users.joins("LEFT JOIN blocks ON users.id = blocks.blocked_user_id AND blocks.user_id = #{u_id}")
         .select("users.*, users.id in (SELECT follows.followed_id from follows WHERE follows.follower_id = #{u_id}) as is_follows")
         .where(blocks: { blocked_user_id: nil }).includes([:profile_attachment])
  end
end
