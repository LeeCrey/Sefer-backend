# frozen_string_literal: true

class CommunityPolicy < ApplicationPolicy
  def posts?
    true
  end

  def add_post?
    true
  end

  private

  def check
    @user.id == @record.user_id
  end
end
