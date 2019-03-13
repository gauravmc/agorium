class AddTaglineToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :tagline, :string, limit: 255
  end
end
