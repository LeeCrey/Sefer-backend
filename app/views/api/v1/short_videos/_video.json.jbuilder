# frozen_string_literal: true

json.extract! video, :id, :caption

json.created_at video.created_at.to_i
json.video_url video.video.public_url

json.user do
  json.extract! video.user, :id, :full_name, :username, :verified
  if user.profile.attached?
    json.profile_picture ''
  else
    json.profile_picture user.profile_picture
  end
end

if video.comments_count.positive?
  val = if video.comments_count == 1
          'comments.single'
        else
          'comments.multiple'
        end

  json.comments_count t(val, value: to_human(video.comments_count))
end

if video.cached_votes_up.positive?
  like = if video.cached_votes_up == 1
           'likes.single'
         else
           'likes.multiple'
         end
  json.votes_count t(like, value: to_human(video.cached_votes_up))
end
