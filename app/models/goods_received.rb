class GoodsReceived < ApplicationRecord
  belongs_to :product
  belongs_to :company_info
end
