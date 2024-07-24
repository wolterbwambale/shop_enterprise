class ChangeQuantityToDecimalInGoodsReceiveds < ActiveRecord::Migration[7.1]
  def change
    change_column :goods_receiveds, :quantity, :decimal, precision: 10, scale: 2
  end
end
