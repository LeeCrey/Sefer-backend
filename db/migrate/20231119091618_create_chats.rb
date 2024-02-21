class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.bigint :receiver_id
      t.integer :chat_type, null: false, default: 1
      t.integer :members_count, null: false, default: 0
      t.string :name
      t.string :description

      t.timestamps
    end

    add_index :chats, :receiver_id
    add_index :chats, %i[user_id receiver_id], unique: true
  end
end
