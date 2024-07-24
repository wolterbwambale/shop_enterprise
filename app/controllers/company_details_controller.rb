class CompanyDetailsController < ApplicationController
    def show
        @company_detail = CompanyDetail.find(params[:id])
    end

    def new
        @company_detail = CompanyDetail.new
    end

    def create
        @company_detail = CompanyDetail.new(company_detail_params)
        if @company_detail.save
            redirect_to root_path
        else
            render :new, status::unprocessable_entity
        end
    end
    
        
        def edit
            @company_detail = CompanyDetail.find(params[:id])
        end

    def update
        @company_detail = CompanyDetail.find(params[:id])
        if @company_detail.update(company_detail_params)
            redirect_to @company_detail
            else
          render :edit
        end
    end 


    def destroy
        @company_detail = CompanyDetail.find([:id])
        @company_detail.destroy
        redirect_to root_path, status: :see_other
    end


    private

    def company_detail_params
        params.require(:company_detail).permit(:name,:address1, :address2, :address3,
         :website, :telephone_number, :tin_number)
    end
end