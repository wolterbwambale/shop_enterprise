class CreateGoodsReceiveds < ActiveRecord::Migration[7.1]
  def change
    create_table :goods_receiveds do |t|
      t.references :product, null: false, foreign_key: true
      t.references :company_info, null: false, foreign_key: true
      t.integer :quantity
      t.datetime :received_date

      t.timestamps
    end
  end
end
