class AddCompanyInfoToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :company_info,  foreign_key: true
  end
end
