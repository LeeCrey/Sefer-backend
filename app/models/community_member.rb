# frozen_string_literal: true

# == Schema Information
#
# Table name: community_members
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  community_id :bigint           not null
#  approved     :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class CommunityMember < ApplicationRecord
  belongs_to :user
  belongs_to :community

  MSG = 'already a members of the community'

  # Validations
  validates :user_id, uniqueness: { scope: :community_id, message: MSG }

  counter_culture :community, column_name: :members_count
end
