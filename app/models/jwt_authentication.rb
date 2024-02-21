# frozen_string_literal: true

# == Schema Information
#
# Table name: jwt_authentications
#
#  id                          :bigint           not null, primary key
#  jti                         :string           not null
#  aud                         :string
#  jwt_authenticable_user_type :string           not null
#  jwt_authenticable_user_id   :bigint           not null
#  exp                         :datetime         not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
class JwtAuthentication < ApplicationRecord
  belongs_to :jwt_authenticable_user, polymorphic: true

  # unique per scope
  validates :jti, presence: true, uniqueness: true
end
