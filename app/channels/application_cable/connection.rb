# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params['Authorization']

      reject_unauthorized_connection if token.nil?

      decode_user(token.split.last) || reject_unauthorized_connection
    end

    def decode_user(token)
      Warden::JWTAuth::UserDecoder.new.call(token, :user, nil) if token
    rescue JWT::DecodeError
      nil
    end
  end
end
