# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # Make sure if user is blocked by the other user
  # Here record is another user btw
  def show?
    check
  end

  def follow?
    check
  end

  def followers?
    account_check
  end

  def followings?
    account_check
  end

  def blocked_users?
    @user.id == @record.id
  end

  def posts?
    account_check
  end

  private

  def check
    return true if @user.id == @record.id

    neither_blocked_nor_blocked_by && !@record.Deactivated?
  end

  # first users should not be blocked by either side(blocked or blocked by)
  # then if account type is private, then user should be followers of that user
  def account_check
    return true if @user.id == @record.id

    if @record.Public?
      neither_blocked_nor_blocked_by
    elsif @record.Deactivated?
      false
    else
      neither_blocked_nor_blocked_by && @user.follows?(@record)
    end
  end

  def neither_blocked_nor_blocked_by
    !@user.blocked_or_blocked_by?(@record.id)
  end
end
