# frozen_string_literal: true

json.okay true

json.posts do
  json.array! @posts, { partial: 'api/v1/posts/community_post', as: :post, user: @user }
end

json.partial! 'api/v1/meta', pagy: @meta
