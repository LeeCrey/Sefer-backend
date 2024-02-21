# frozen_string_literal: true

class ShortVideoPolicy < ApplicationPolicy
  # for sub resource(comments)
  def index?
    owner_or_not_blocked?
  end

  private

  def check
    @user.id == @record.user_id
  end
end
