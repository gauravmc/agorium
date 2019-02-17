class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 255
      t.string :phone, null: false, limit: 10

      t.timestamps
    end
    add_index :users, :phone, unique: true
  end
end
