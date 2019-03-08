class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :address_line_1, null: false, limit: 255
      t.string :address_line_2, limit: 255
      t.string :landmark, limit: 255
      t.string :city, null: false
      t.string :state, null: false
      t.string :pincode, null: false, limit: 6
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
