# frozen_string_literal: true

# Copy pasted from devise-jwt and strategy allow list
# Then modified
module AuthenticableConcern
  extend ActiveSupport::Concern
  included do
    has_many :jwt_authentications, as: :jwt_authenticable_user, dependent: :destroy

    def self.jwt_revoked?(payload, user)
      !user.jwt_authentications.exists?(payload.slice('jti', 'aud'))
    end

    def self.revoke_jwt(payload, user)
      user.jwt_authentications.destroy_by(payload.slice('jti', 'aud'))
    end
  end

  def on_jwt_dispatch(_token, payload)
    jwt_authentications.create!(
      jti: payload['jti'],
      aud: payload['aud'],
      exp: Time.at(payload['exp'].to_i)
    )
  end
end
