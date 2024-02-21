class CreateCommunityMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :community_members do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :community, null: false, foreign_key: true
      t.boolean :approved

      t.timestamps
    end
  end
end
