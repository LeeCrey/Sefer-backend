# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

  def update?
    check
  end

  def destroy?
    check
  end

  def vote?
    owner_or_not_blocked?
  end

  # the same
  def users?
    owner_or_not_blocked?
  end

  def owner_or_not_blocked?
    return true if @record.user_id == @user.id

    !@user.blocked_or_blocked_by?(@record.user_id)
  end

  private

  def check
    raise NotImplementedError, "You must define #resolve in #{self.class}"
  end
end
