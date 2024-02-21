# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def show?
    owner_or_not_blocked?
  end

  def create?
    owner_or_not_blocked?
  end

  private

  def check
    @record.user_id == @user.id
  end
end
