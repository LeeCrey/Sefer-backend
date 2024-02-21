# frozen_string_literal: true

json.okay true

json.products do
  json.array! @products, partial: 'api/v1/products/product', as: :product
end

json.partial! 'api/v1/meta', pagy: @meta
