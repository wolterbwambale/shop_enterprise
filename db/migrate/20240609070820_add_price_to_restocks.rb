class AddPriceToRestocks < ActiveRecord::Migration[7.1]
  def change
    add_column :restocks, :price, :decimal, precision: 10, scale: 2
  end
end
