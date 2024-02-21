# frozen_string_literal: true

json.okay true
json._message t('devise.sessions.signed_in')

json.user do
  json.extract! current_user, :id, :full_name, :username, :verified
  if current_user.profile.attached?
    json.profile_picture ''
  else
    json.profile_picture current_user.profile_picture
  end
end
