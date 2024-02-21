# frozen_string_literal: true

json.users do
  json.array! @users, partial: 'api/v1/follows/follower', as: :user
end

json.partial! 'api/v1/meta', pagy: @meta
