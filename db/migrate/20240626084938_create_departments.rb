class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :code
      t.string :department_name

      t.timestamps
    end
  end
end
