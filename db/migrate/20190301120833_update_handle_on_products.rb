class UpdateHandleOnProducts < ActiveRecord::Migration[5.2]
  def change
    add_index :products, [:handle, :owner_id], unique: true
  end
end
