class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, null: false
      t.string :description
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
