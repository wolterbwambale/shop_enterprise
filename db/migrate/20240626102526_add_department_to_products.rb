class AddDepartmentToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :department, foreign_key: true
  end
end
