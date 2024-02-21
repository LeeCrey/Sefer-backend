# frozen_string_literal: true

json.extract! chat, :id, :chat_type

json.extract! chat, :name, :description if chat.group_chat?

json.updated_at chat.updated_at.to_i
