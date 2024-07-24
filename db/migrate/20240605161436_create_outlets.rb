class CreateOutlets < ActiveRecord::Migration[7.1]
  def change
    create_table :outlets do |t|
      t.references :product, null: false, foreign_key: true
      t.references :outlet_type, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
