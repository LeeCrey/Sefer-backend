# frozen_string_literal: true

json.okay true

json.replies do
  json.array! @replies, partial: 'api/v1/comments/comment', as: :comment
end
