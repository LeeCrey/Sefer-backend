# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false
      t.bigint :followed_id, null: false
      t.boolean :approved, null: false

      t.timestamps
    end

    add_index :follows, :follower_id
    add_index :follows, :followed_id
    add_index :follows, %i[follower_id followed_id]
  end
end
