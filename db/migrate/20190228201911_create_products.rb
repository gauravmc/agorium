class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 255
      t.text :description, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.decimal :cost, null: false, precision: 10, scale: 2
      t.string :handle, null: false, limit: 255
      t.datetime :published_at
      t.integer :inventory, null: false
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
