# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.bigint :community_id # optional
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :cached_votes_up, null: false, default: 0
      t.integer :comments_count, null: false, default: 0
      t.boolean :pinned, null: false, default: false

      t.timestamps
    end
  end
end
