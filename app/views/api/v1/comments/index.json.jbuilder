# frozen_string_literal: true


def to_human(value)
  number_to_human(value, format: '%n%u', units: { thousand: 'K', million: 'M' })
end

json.okay true

json.comments do
  json.array! @comments, partial: 'api/v1/comments/comment', as: :comment
end

json.partial! 'api/v1/meta', pagy: @meta
