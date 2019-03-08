class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name, null: false, limit: 255
      t.string :phone, null: false, limit: 10
      t.boolean :phone_verified, default: false
      t.index :phone, unique: true

      t.timestamps
    end
  end
end
