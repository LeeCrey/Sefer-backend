# frozen_string_literal: true

# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  votable_type :string
#  votable_id   :bigint
#  voter_type   :string
#  voter_id     :bigint
#  vote_flag    :boolean
#  vote_scope   :string
#  vote_weight  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :voter, polymorphic: true

  # Validations
  validates :voter_id, uniqueness: { scope: :votable_id }

  # For join
  belongs_to :post, -> { where(votes: { votable_type: 'Post' }) }, foreign_key: :votable_id
end
