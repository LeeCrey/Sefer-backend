# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  price       :decimal(, )      not null
#  description :string
#  shop_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord
  belongs_to :shop
  has_one_attached :cover
  has_many_attached :images

  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  validates :cover, attached: true,
                    processable_image: true,
                    content_type: %i[png jpg jpeg],
                    size: { less_than: 2.megabytes, message: 'is too large' }
  validates :images, attached: true,
                     processable_image: true,
                     content_type: %i[png jpg jpeg],
                     size: { less_than: 2.megabytes, message: 'is too large' },
                     limit: { min: 1, max: 5 }
end
