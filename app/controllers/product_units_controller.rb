class ProductUnitsController <ApplicationController
    def index
        @product_units =ProductUnit.all.order(:id)
        respond_to do |format|
        format.html
        format.pdf do
          pdf = ListUnitPdf.new(@product_units)
          send_data pdf.render, filename:"units.pdf",type:"application/pdf",disposition:"inline"         
            end
          end
    end

    def show
        @product_unit =ProductUnit.find(params[:id])
    end

    def new
        @product_unit = ProductUnit.new
      end

      def create
        @product_unit = ProductUnit.new(product_unit_params)
    
        if @product_unit.save
          redirect_to @product_unit, notice: 'Unit was successfully created.'
        else
            puts @product_unit.errors.full_messages.inspect
          render :new
        end
      end

      def edit
        @product_unit = ProductUnit.find(params[:id])
      end

      def update
        @product_unit = ProductUnit.find(params[:id])
        if @product_unit.update(product_unit_params)
          redirect_to product_units_path, notice: "Product unit was successfully updated."
        else
          render :edit
        end
      end
      

    def destroy
      @product_unit = ProductUnit.find(params[:id])
        @product_unit.destroy
        redirect_to product_units_url, notice: 'Product unit was successfully destroyed.'
    end
  
    private 
      def product_unit_params
        params.require(:product_unit).permit(:code, :title, :description)
      end
end