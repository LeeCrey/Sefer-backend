# frozen_string_literal: true

json.users do
  json.array! @users, { partial: 'api/v1/follows/following', as: :user, is_current_user: @is_current_user }
end

json.partial! 'api/v1/meta', pagy: @meta
