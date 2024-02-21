# frozen_string_literal: true

json.communities do
  json.array! @communities, partial: 'api/v1/communities/community', as: :community
end

json.partial! 'api/v1/meta', pagy: @meta
