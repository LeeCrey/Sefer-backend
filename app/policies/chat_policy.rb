# frozen_string_literal: true

class ChatPolicy < ApplicationPolicy
  def destroy?
    return check if @record.group_chat?

    Chat.user_chats(@user.id)
  end

  private

  def check
    @record.user_id = @user.id
  end
end
