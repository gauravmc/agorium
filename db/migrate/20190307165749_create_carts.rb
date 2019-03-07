class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.references :brand, foreign_key: true, null: false

      t.timestamps
    end
  end
end
