# frozen_string_literal: true

json.okay true

json.user do
  json.extract! @user, :id, :full_name, :gender, :country, :biography, :verified, :username

  json.followers_count @followers_count
  json.followings_count @followings_count
  json.posts_count @posts_count

  profile = if @user.profile.attached?
              @user.profile.public_url
            else
              @user.profile_picture
            end

  json.profile_picture profile

  json.cover_picture @user.cover_picture.public_url if @user.cover_picture.attached?
end
