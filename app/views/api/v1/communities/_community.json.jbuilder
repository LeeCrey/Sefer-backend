# frozen_string_literal: true

json.extract! community, :id, :name, :description, :community_type, :members_count
json.is_owner community.user_id == current_user.id
json.profile 'https://w7.pngwing.com/pngs/359/743/png-transparent-logo-community-text-logo-television-show.png'
