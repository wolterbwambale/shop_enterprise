class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
    
    before_save :calculate_total_amount
  
    def calculate_total_amount
      self.total_price = order_items.map { |item| item.quantity * item.product_detail.price }.sum
    end
  end
  