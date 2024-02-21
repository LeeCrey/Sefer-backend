# frozen_string_literal: true

json.okay true
json._message t('updated', resource: 'Chat')

json.chat do
  json.id @chat.id
  json.updated_at @chat.updated_at.to_i
end
