class ChangeQuantityToDecimalInProduct < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :quantity, :decimal, precision: 10, scale: 2
  end
end
