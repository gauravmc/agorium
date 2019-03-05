class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands do |t|
      t.string :name, null: false, limit: 255
      t.string :username, null: false, limit: 42
      t.text :story
      t.string :city, null: false
      t.string :state, null: false
      t.belongs_to :owner, null: false, foreign_key: { to_table: :users }, index: { unique: true }

      t.timestamps
    end
    add_index :brands, :username, unique: true
  end
end
