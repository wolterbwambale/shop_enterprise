class CompanyInfosController<ApplicationController
    
def index
    @company_infos = CompanyInfo.all.order(:id).page(params[:page]).per(10)
    respond_to do |format|
        format.html
        format.pdf do
          pdf = CompanyPdf.new(@company_infos)
          send_data pdf.render, filename: "companies.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
      end
end

def show
    @company_info = CompanyInfo.find(params[:id])
end

def new
    @company_info = CompanyInfo.new
end

def create
    @company_info = CompanyInfo.new(param_company)
    if @company_info.save
     redirect_to @company_info
    else
        render :new, status: :unprocessable_entity
    end
end

def edit
    @company_info = CompanyInfo.find(params[:id])
end

def update
    @company_info = CompanyInfo.find(params[:id])
    if @company_info.update(param_company)
        redirect_to @company_info
        else
            render :edit
        end
end

def destroy
    @company_info.CompanyInfo.find(params[:id])
    @company_info.destroy
    redirect_to company_infos
end

private

def param_company
params.require(:company_info).permit(:company_name, :website, :physical_address,
 :address, :postal_box, :telephone,:Tin_number)
end
end