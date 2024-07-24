class ProductDetail < ApplicationRecord
    belongs_to :category
    has_many :orders
    has_many :order_items, through: :order_items
end
