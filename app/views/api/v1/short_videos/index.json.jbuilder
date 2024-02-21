# frozen_string_literal: true

def to_human(value)
  number_to_human(value, format: '%n%u', units: { thousand: 'K', million: 'M' })
end

json.okay true

json.short_videos do
  json.array! @videos, partial: 'api/v1/short_videos/video', as: :video
end

json.partial! 'api/v1/meta', pagy: @meta
