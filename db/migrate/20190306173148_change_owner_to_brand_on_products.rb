class ChangeOwnerToBrandOnProducts < ActiveRecord::Migration[5.2]
  def change
    product_owner_ids = {}
    Product.find_each do |product|
      product_owner_ids[product.id] = product.owner_id
    end

    remove_foreign_key :products, :users

    product_owner_ids.each do |p_id, u_id|
      product = Product.find(p_id)
      user = User.find(u_id)
      product.owner_id = user.brand.id
      product.save
    end

    add_foreign_key :products, :brands, column: :owner_id
  end
end
