# frozen_string_literal: true

json.extract! post, :id, :content, :user_id, :is_voted, :comments_count

json.votes_count post.cached_votes_up
json.created_at post.created_at.to_i

json.tag_list post.tags.map { |x| "##{x}" }.join(' ')

json.user do
  json.extract! post.user, :id, :full_name, :username, :verified
  if post.user.profile.attached?
    json.profile_picture ''
  else
    json.profile_picture post.user.profile_picture
  end
end
