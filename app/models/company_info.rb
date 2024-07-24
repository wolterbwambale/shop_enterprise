class CompanyInfo < ApplicationRecord
    has_many :products, dependent: :nullify
   

    validates :company_name, presence:true, uniqueness:{message:"already exists"}
end
