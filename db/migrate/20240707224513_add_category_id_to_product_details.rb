class AddCategoryIdToProductDetails < ActiveRecord::Migration[7.1]
  def change
    add_reference :product_details, :category, foreign_key: true
  end
end
