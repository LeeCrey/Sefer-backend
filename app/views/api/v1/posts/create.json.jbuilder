# frozen_string_literal: true

json.okay true
json._message t('created', resource: 'Post')

json.post do
  json.extract! @post, :id, :user_id
  json.created_at @post.created_at.to_i

  json.partial! 'api/v1/user', user: current_user
end
