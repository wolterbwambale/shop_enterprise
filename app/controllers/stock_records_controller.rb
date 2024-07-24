class StockRecordsController < ApplicationController
    # def index
    #   @stock_records = StockRecord.all
    # end

    def index
        @company = CompanyInfo.find(params[:company_id]) if params[:company_id].present?
        @products = @company ? @company.products : Product.all
      end
  
    # def company_stock_records
    #   @company = CompanyInfo.find(params[:company_id])
    #   @stock_records = @company.stock_records
    # end
  end
  