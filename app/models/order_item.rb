class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_detail
end
