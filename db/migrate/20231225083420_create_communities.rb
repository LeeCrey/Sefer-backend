# frozen_string_literal: true

class CreateCommunities < ActiveRecord::Migration[7.1]
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.string :description
      t.integer :community_type, null: false, default: 0
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :members_count, null: false, default: 0

      t.timestamps
    end
  end
end
