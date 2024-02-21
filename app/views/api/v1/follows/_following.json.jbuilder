# frozen_string_literal: true

json.extract! user, :id, :full_name, :verified
json.is_follow is_current_user || user.is_follow

if user.profile.attached?
  json.profile_picture 'replace with file url'
else
  json.profile_picture user.profile_picture
end
