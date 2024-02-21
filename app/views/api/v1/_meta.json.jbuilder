# frozen_string_literal: true

json.metadata do
  json.extract! pagy, :page, :next, :prev
  json.count pagy.in
end
