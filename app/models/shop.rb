# frozen_string_literal: true

# == Schema Information
#
# Table name: shops
#
#  id                     :bigint           not null, primary key
#  name                   :string           not null
#  latitude               :decimal(, )      not null
#  longitude              :decimal(, )      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
class Shop < ApplicationRecord
  include AuthenticableConcern

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  #  Validations
  validates :name, presence: true

  # R/ships
  has_many :products, dependent: :destroy
end
