class Restock < ApplicationRecord
  belongs_to :product

  validates :quantity,presence: true
  validates :price, presence: true

  def total_amount_restock
      return 0 if price.nil? || quantity.nil? || price.zero? || quantity.zero?
      price * quantity
    end
end
