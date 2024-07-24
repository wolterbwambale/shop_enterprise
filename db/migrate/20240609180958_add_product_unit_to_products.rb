class AddProductUnitToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :product_unit, foreign_key: true
  end
end
