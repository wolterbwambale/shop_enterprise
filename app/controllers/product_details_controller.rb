class ProductDetailsController < ApplicationController
    def index
        @product_details = ProductDetail.all.order(:id)
        @categories = Category.all
    end

    def show
        @product_detail = ProductDetail.find(params[:id])
    end

    def new
        @product_detail = ProductDetail.new
        @categories = Category.all
    end

    def create
        @product_detail = ProductDetail.new(product_detail_params)
        if @product_detail.save
            redirect_to product_details_path
        else
            render :new
       end
     end

     def edit
        @product_detail = ProductDetail.find(params[:id])
        @categories = Category.all
     end

     def update
        @product_detail = ProductDetail.find(params[:id])
        if @product_detail.update(product_detail_params)
          redirect_to product_details_path, notice: "Product detail was successfully updated."
        else
            @categories = Category.all
            render :edit
        end
     end

     def destroy
        @product_detail = ProductDetail.find(params[:id])
        @product_detail.destroy
        redirect_to product_details_path, notice: "Product detail was successfully deleted." 
     end

     private
     
     def product_detail_params
        params.require(:product_detail).permit(:name, :quantity, :price, :category_id)
      end
end