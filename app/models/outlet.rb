class Outlet < ApplicationRecord
  belongs_to :product
  belongs_to :outlet_type
end
