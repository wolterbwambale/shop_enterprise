class RestocksController < ApplicationController
    def restock
      @product = Product.find(params[:id])
      quantity_to_add = params[:quantity].to_i
      price = params[:price].to_f
      company_info = CompanyInfo.find(params[:company_info_id])
  
      StockRecord.create!(product: @product, company_info: company_info, quantity: quantity_to_add, price: price)
  
      redirect_to @product, notice: "Successfully logged restocking of #{quantity_to_add} items from #{company_info.company_name}."
    end
  end
  