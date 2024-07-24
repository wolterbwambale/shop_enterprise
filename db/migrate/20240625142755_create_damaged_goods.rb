class CreateDamagedGoods < ActiveRecord::Migration[7.1]
  def change
    create_table :damaged_goods do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.text :damage_reason
      t.datetime :damaged_date

      t.timestamps
    end
  end
end
