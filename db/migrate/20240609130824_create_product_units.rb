class CreateProductUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :product_units do |t|
      t.string :code
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
