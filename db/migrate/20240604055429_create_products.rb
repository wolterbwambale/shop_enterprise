class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :product_name
      t.decimal :price
      t.integer :quantity

      t.timestamps
    end
  end
end
