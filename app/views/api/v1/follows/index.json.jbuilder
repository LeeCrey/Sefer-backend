# frozen_string_literal: true

json.okay true

json.users do
  json.array! @users, partial: 'api/v1/users/user', as: :user
end

json.partial! 'api/v1/meta', pagy: @meta
