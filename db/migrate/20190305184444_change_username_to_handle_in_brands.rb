class ChangeUsernameToHandleInBrands < ActiveRecord::Migration[5.2]
  def change
    Brand.destroy_all
    remove_column :brands, :username
    add_column :brands, :handle, :string, limit: 255
    add_index :brands, :handle, unique: true
  end
end
