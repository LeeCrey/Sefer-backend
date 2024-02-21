# frozen_string_literal: true

json.okay true

json.posts do
  json.array! @posts, { partial: 'api/v1/posts/user_post', as: :post, user: current_user }
end

json.partial! 'api/v1/meta', pagy: @meta
