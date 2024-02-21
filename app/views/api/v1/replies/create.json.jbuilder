# frozen_string_literal: true

json.okay true
json._message t('created', resource: 'Reply')

json.comment do
  json.partial! @reply, as: :comment
end
