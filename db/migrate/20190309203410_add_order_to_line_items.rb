class AddOrderToLineItems < ActiveRecord::Migration[5.2]
  def change
    change_column_null :line_items, :cart_id, true
    add_reference :line_items, :order, foreign_key: true
  end
end
