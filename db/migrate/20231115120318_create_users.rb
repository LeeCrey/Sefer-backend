# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :username
      t.integer :gender
      t.string :country
      t.string :biography
      t.string :uid
      t.string :provider
      t.string :provier_profile_url
      t.boolean :verified, null: false, default: false
      t.integer :account_type, null: false, default: 0
      t.string :notification_token

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :full_name
    add_index :users, :uid
    add_index :users, :provider
    add_index :users, %i[uid provider]
    add_index :users, :account_type
  end
end
