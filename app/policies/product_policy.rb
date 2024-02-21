# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.is_a? User
        @scope.order(id: :desc)
      else
        @user.products.order(id: :desc)
      end
    end
  end

  # add conditions where shop paid, ..
  def create?
    true
  end

  private

  # create, update and destroy(current user -> shop)
  def check
    @record.shop_id == @user.id
  end
end
