class CreateOrders < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE order_status AS ENUM (
        'pending', 'confirmed', 'shipped', 'cancelled'
      );
    SQL

    create_table :orders do |t|
      t.references :brand, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_price, null: false, precision: 10, scale: 2
      t.column :status, :order_status

      t.timestamps
    end
  end

  def down
    drop_table :orders
    execute "DROP type order_status;"
  end
end
