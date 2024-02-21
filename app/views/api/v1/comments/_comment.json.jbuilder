# frozen_string_literal: true

json.extract! comment, :id, :content, :commentable_type, :commentable_id

if comment.cached_votes_up.positive?
  v_val = if comment.cached_votes_up == 1
            'likes.single'
          else
            'likes.multiple'
          end

  json.votes_count t(v_val, value: to_human(comment.cached_votes_up))
end

if comment.replies_count.positive?
  val = if comment.replies_count == 1
          'reply.single'
        else
          'reply.multiple'
        end

  json.replies_count t(val, value: to_human(comment.replies_count))
end

json.created_at comment.created_at.to_i

json.user do
  json.extract! comment.user, :id, :full_name, :username, :profile_picture
end
