class CreateCompanyDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :company_details do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :website
      t.string :telephone_number
      t.string :tin_number

      t.timestamps
    end
  end
end
