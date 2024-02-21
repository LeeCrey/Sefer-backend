# frozen_string_literal: true

json.okay true

json.chats do
  json.array! @chats, partial: 'api/v1/chats/chat', as: :chat
end
