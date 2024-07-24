class CreateCompanyInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :company_infos do |t|
      t.string :company_name
      t.string :website
      t.string :physical_address
      t.string :address
      t.string :postal_box
      t.integer :telephone
      t.integer :Tin_number

      t.timestamps
    end
  end
end
