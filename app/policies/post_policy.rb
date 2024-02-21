# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  # for sub-resource(comments)
  def index?
    owner_or_not_blocked?
  end

  def show?
    owner_or_not_blocked?
  end

  # for sub-resource(comments)
  def create?
    owner_or_not_blocked?
  end

  def pin?
    @record.id == @post.user_id
  end

  private

  def check
    @user.id == @record.user_id
  end
end
