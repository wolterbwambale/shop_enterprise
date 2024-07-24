class ChangeQuantityToDecimalInDemagedGoods < ActiveRecord::Migration[7.1]
  def change
    change_column :damaged_goods, :quantity, :decimal, precision: 10, scale: 2
  end
end
