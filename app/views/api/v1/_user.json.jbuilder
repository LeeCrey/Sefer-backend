# frozen_string_literal: true

json.user do
  json.extract! user, :id, :full_name, :username, :profile_picture
end
