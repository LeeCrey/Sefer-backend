# frozen_string_literal: true

class CreateShortVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :short_videos do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :caption
      t.integer :cached_votes_up, null: false, default: 0
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end
  end
end
