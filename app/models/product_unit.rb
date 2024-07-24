class ProductUnit < ApplicationRecord
    has_many :products, dependent: :nullify
end
