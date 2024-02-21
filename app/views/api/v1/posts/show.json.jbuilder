# frozen_string_literal: true

# frozen_string_literal: true

json.extract! @post, :id, :content, :user_id
json.created_at @post.created_at.to_i

json.user do
  json.extract! @post.user, :id, :full_name, :username, :verified
  if @post.user.profile.attached?
    json.profile_picture ''
  else
    json.profile_picture @post.user.profile_picture
  end
end
