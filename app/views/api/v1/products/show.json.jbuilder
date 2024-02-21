# frozen_string_literal: true

json.okay true

json.product do
  json.extract! product, :id, :name, :shop_id, :description, :price
end
