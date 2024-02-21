# frozen_string_literal: true

json.extract! user, :id, :full_name, :verified

if user.profile.attached?
  json.profile_picture 'replace with file url'
else
  json.profile_picture user.profile_picture
end
