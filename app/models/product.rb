class Product < ApplicationRecord
    belongs_to :product_unit, dependent: :destroy
    belongs_to :department, dependent: :destroy
    has_many :restocks, dependent: :destroy
    has_many :outlets, dependent: :destroy
    belongs_to :company_info, dependent: :destroy
    has_many :goods_receiveds
    has_many :damaged_goods, dependent: :destroy
    has_many :order_items
    has_many :orders, through: :order_items

   

    validates :product_name, uniqueness: true
    validates :quantity, presence: true
    def total_amount
        price*quantity
    end

    def discount(amount_discounted)
        total_amount*(1-amount_discounted)
    end

    def tax_inclusive(tax)
        (1-tax)*total_amount
    end

    def item_without_net_amount(tax)
        price*(1-tax)
    end

    def tax(tax)
        price * (1*tax)
    end

    
end
