# frozen_string_literal: true

module UserConcern
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    acts_as_voter

    with_options dependent: :destroy do |assoc|
      assoc.has_one_attached :profile
      assoc.has_one_attached :cover_picture

      assoc.has_many :blocks, class_name: 'Block', foreign_key: :user_id
      assoc.has_many :reverse_block, class_name: 'Block', foreign_key: :blocked_user_id
      assoc.has_many :follows, class_name: 'Follow', foreign_key: :follower_id
      assoc.has_many :passive_friendships, class_name: 'Follow', foreign_key: :followed_id

      # chat
      assoc.has_many :owned_chats, class_name: 'Chat', foreign_key: :user_id
      assoc.has_many :received_chats, class_name: 'Chat', foreign_key: :receiver_id

      assoc.has_many :posts
      assoc.has_many :comments
      assoc.has_many :short_videos
      assoc.has_many :community_members
      assoc.has_many :owned_communities, class_name: 'Community'
    end
    has_many :blocked_users, through: :blocks, source: :blocked_user
    has_many :blocking_users, through: :reverse_block, source: :user
    has_many :following_users, through: :follows, source: :followed
    has_many :followers, through: :passive_friendships, source: :follower
    has_many :communities, through: :community_members

    validates :cover_picture, processable_image: true,
                              content_type: %i[png jpg jpeg],
                              size: { less_than: 1.megabytes,
                                      message: 'is too large' },
                              if: -> { cover_picture.attached? }
    validates :profile, processable_image: true,
                        content_type: %i[png jpg jpeg],
                        size: { less_than: 1.megabytes,
                                message: 'is too large' },
                        if: -> { profile.attached? }
  end

  def following_users_with_status(u_id)
    following_users.includes([:profile_attachment]).select("users.*, users.id in (SELECT follows.followed_id FROM
     follows WHERE follows.follower_id = #{u_id}) as is_follow")
  end

  def followers_with_status(u_id)
    followers.includes([:profile_attachment]).select("users.*, users.id in (SELECT follows.followed_id from follows
     WHERE follows.follower_id = #{u_id}) as is_follows")
  end

  def posts_with_status(u_id)
    posts.with_attached_photos
         .joins("LEFT JOIN votes ON votes.votable_id = posts.id AND votes.votable_type = 'Post' AND
          votes.voter_id = #{u_id}")
         .select('posts.*, CASE WHEN votes.votable_id IS NOT NULL THEN true ELSE false END as is_voted')
         .order(id: :desc)
  end

  def posts_all(u_id)
    posts.includes(:tags, :community).with_attached_photos
         .joins("LEFT JOIN votes ON votes.votable_id = posts.id AND votes.votable_type = 'Post' AND
     votes.voter_id = #{u_id}")
         .select('posts.*, CASE WHEN votes.votable_id IS NOT NULL THEN true ELSE false END as is_voted')
         .order(id: :desc)
  end

  def to_s
    full_name
  end

  def unfollow(user)
    follows.destroy_by(followed_id: user.id)
  end

  def unblock(user)
    blockings.destroy_by(blocked_user_id: user.id)
  end

  def follows?(user)
    follows.exists?(followed_id: user.id)
  end

  def blocked?(user)
    blockings.exists?(blocked_user_id: user.id)
  end

  # a user is blocked or blocked by that user
  def blocked_or_blocked_by?(u_id)
    Block.find_by_sql("SELECT * FROM blocks WHERE (user_id = #{id} AND blocked_user_id = #{u_id})
    OR (user_id = #{u_id} AND blocked_user_id = #{id}) LIMIT 1").present?
  end

  def profile_picture
    holder = 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
    provier_profile_url || holder
  end
end
