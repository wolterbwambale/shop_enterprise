class OutletType < ApplicationRecord
    has_many :Outlets, dependent: :destroy
end
