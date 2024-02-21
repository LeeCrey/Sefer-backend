# frozen_string_literal: true

json.okay true
json._message t('created', resource: 'Comment')

json.comment do
  json.partial! @comment, as: :comment
end
