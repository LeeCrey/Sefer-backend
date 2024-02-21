# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  full_name              :string           not null
#  username               :string
#  gender                 :integer
#  country                :string
#  biography              :string
#  uid                    :string
#  provider               :string
#  provier_profile_url    :string
#  verified               :boolean          default(FALSE), not null
#  account_type           :integer          default("Public"), not null
#  notification_token     :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :confirmable, :trackable,
         :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  encrypts :username, :full_name, deterministic: true
  encrypts :country # non deterministic

  enum gender: { Male: 0, Female: 1 }, _scopes: false
  enum account_type: { Public: 0, Private: 1, Deactivated: 3 }

  # Validations
  validates :full_name, presence: true
  validates :username, uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 },
                       if: -> { username.present? }
  validates :gender, inclusion: { in: genders.keys },
                     if: -> { gender.present? }

  def self.from_google_payload(auth)
    provide = 'google'
    user = find_or_create_by(provider: provide, uid: auth['sub'])

    return user if user.email == auth['email']

    register_user(user, auth)
  end

  def self.register_user(user, auth) # rubocop:disable Metrics/AbcSize
    user.uid = auth['sub']
    user.full_name = auth['name']
    user.provider = provide
    user.provier_profile_url = auth['picture']
    user.email = auth['email']
    user.password = Devise.friendly_token[0, 20]

    user.confirm if auth['email_verified']
    user.save
    user
  end

  def self.neither_blocked_nor_followed_by(u_id)
    joins("LEFT JOIN follows ON users.id = follows.followed_id AND follows.follower_id = #{u_id}")
      .joins("LEFT JOIN blocks ON users.id = blocks.blocked_user_id AND blocks.user_id = #{u_id}")
      .where(follows: { followed_id: nil }).where(blocks: { blocked_user_id: nil })
      .where(users: { confirmation_token: nil })
      .includes([:profile_attachment]).Public.where.not(id: u_id).order(id: :desc)
  end

  include UserConcern
  include AuthenticableConcern

  private_class_method :register_user
end
