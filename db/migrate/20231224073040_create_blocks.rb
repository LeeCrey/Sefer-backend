# frozen_string_literal: true

class CreateBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :blocks do |t|
      t.bigint :user_id, null: false
      t.bigint :blocked_user_id, null: false

      t.timestamps
    end
    add_index :blocks, :user_id
    add_index :blocks, :blocked_user_id
    add_index :blocks, %i[blocked_user_id user_id]
  end
end
