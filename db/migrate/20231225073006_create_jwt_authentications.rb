# frozen_string_literal: true

class CreateJwtAuthentications < ActiveRecord::Migration[7.1]
  def change
    create_table :jwt_authentications do |t|
      t.string :jti, null: false
      t.string :aud
      t.references :jwt_authenticable_user, polymorphic: true, null: false
      t.datetime :exp, null: false

      t.timestamps
    end

    add_index :jwt_authentications, :jti, unique: true
  end
end
