class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
    def index
      @products = Product.all.order(:id)
  
      if params[:search].present?
        @products = @products.where("product_name LIKE ?", "%#{params[:search]}%")
      end
  
      if params[:period] && params[:from_date] && params[:to_date]
        period = params[:period]
        from_date = params[:from_date].to_date
        to_date = params[:to_date].to_date
  
        @products = case period
                    when "day"
                      @products.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
                    when "month"
                      @products.where(created_at: from_date.beginning_of_month..to_date.end_of_month)
                    when "year"
                      @products.where(created_at: from_date.beginning_of_year..to_date.end_of_year)
                    else
                      @products
                    end
      end
  
      if params[:department_id].present?
        @products = @products.where(department_id: params[:department_id])
      end
  
      # Calculate grand total for all products matching the search criteria
      @grand_total = @products.sum { |product| product.price * product.quantity }
  
      # Apply pagination after filtering and calculating the grand total
      @products = @products.page(params[:page]).per(10)
  
      respond_to do |format|
        format.html
        format.pdf do
          pdf = ProductPdf.new(@products, @grand_total, period: params[:period], from_date: params[:from_date], to_date: params[:to_date])
          send_data pdf.render, filename: "products.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end
  

def self.search(search)
  if search
    where('product_name LIKE ?', "%#{search}%")
  else
    all
  end
end

  def show
    @product = Product.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ProductPdf.new(@product)
        send_data pdf.render, filename:"df.pdf",type:"application/pdf",disposition:"inline"
     end
    end
   end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to root_path, notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to root_path, notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def destroy
  #   @product = Product.find(params[:id])
  #   @product.destroy
  #   redirect_to root_path, status: :see_other, notice: 'Product was successfully deleted.'
  # end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to products_path, status: :see_other, notice: 'Product was successfully deleted.'
    else
      redirect_to products_path, alert: 'Failed to delete product.'
    end
  end

  def restock
    @product = Product.find(params[:id])
    quantity_to_add = params[:quantity].to_f
    @product.quantity += quantity_to_add

    if @product.save
      Restock.create(product: @product, quantity: quantity_to_add, price: @product.price)
      redirect_to @product, notice: "Successfully restocked #{quantity_to_add} items."
    else
      redirect_to @product, alert: "Failed to restock items."
    end
  end

  def issue
    @product = Product.find(params[:id])
    @outlet_type_id = params[:product][:outlet_type_id]
    quantities = Array.wrap(params[:product][:quantity])

    quantities.each do |quantity|
      next if quantity.blank? || quantity.to_i.zero?

      if @product.quantity >= quantity.to_f
        @product.quantity -= quantity.to_f
        @product.save

        Outlet.create!(product_id: @product.id, quantity: quantity.to_f, outlet_type_id: @outlet_type_id)
      else
        redirect_to @product, alert: "Invalid quantity or insufficient stock for issue."
        return
      end
    end

    redirect_to @product, notice: "Successfully issued products to Outlet Type #{@outlet_type}."
  end

  def issued_products
    @product = Product.find(params[:id])
    @issued_outlets = @product.outlets.includes(:outlet_type)
  end

  def select_for_issue
    @products = Product.all.order(:id)
  end

    def issue_multiple
      # Handle search functionality
      @products = if params[:search]
                    Product.where("product_name LIKE ?", "%#{params[:search]}%")
                  else
                    Product.all
                  end
  
      # Handle product issuance logic only for POST requests
      if request.post?
        product_ids = params[:product_ids]
        quantities = params[:quantities].map(&:to_f)
        outlet_type_id = params[:product][:outlet_type_id].to_f
  
        product_ids.each_with_index do |product_id, index|
          quantity_to_issue = quantities[index]
          next if quantity_to_issue.zero?
  
          @product = Product.find(product_id)
          if @product.quantity >= quantity_to_issue
            @product.quantity -= quantity_to_issue
            @product.save
  
            Outlet.create(product_id: @product.id, quantity: quantity_to_issue, outlet_type_id: outlet_type_id)
          end
        end
  
        redirect_to products_path, notice: "Products successfully issued to the selected outlet type."
      end
    end

  
  
  def product_detailed_summary
    @products = Product.all.order(:id)
    @issued_products = Outlet.includes(:product, :outlet_type)

    if params[:period] && params[:from_date] && params[:to_date]
      period = params[:period]
      from_date = params[:from_date].to_date
      to_date = params[:to_date].to_date

      @issued_products = case period
                         when "day"
                           @issued_products.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
                         when "month"
                           @issued_products.where(created_at: from_date.beginning_of_month..to_date.end_of_month)
                         when "year"
                           @issued_products.where(created_at: from_date.beginning_of_year..to_date.end_of_year)
                         else
                           @issued_products
                         end
    else
      @issued_products = Outlet.none
    end
    respond_to do |format|
      format.html
       format.pdf do
         pdf = IssuedDetailedPdf.new(@issued_products , period: params[:period],
         from_date: params[:from_date], to_date: params[:to_date])
         send_data pdf.render, filename:"issued_details.pdf",type:"application/pdf",disposition:"inline"         
           end
         end
  end


  

  def issued_products_summary
    from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : Date.today.beginning_of_month
    to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : Date.today.end_of_month
    outlet_type_id = params[:outlet_type_id]
    @outlet_type = OutletType.find_by(id: outlet_type_id)
  
    issued_products_summary_for_period(from_date, to_date, outlet_type_id)
  
    respond_to do |format|
      format.html
      format.pdf do
        pdf = IssuedSummaryPdf.new(@issued_products_summary, period: params[:period], from_date: params[:from_date], to_date: params[:to_date], outlet_type: @outlet_type)
        send_data pdf.render, filename: "units.pdf", type: "application/pdf", disposition: "inline", orientation: :landscape
      end
    end
  end

  
  

  #viewing the general report
  # def company_products
  #   if params[:company_id].present?
  #     @company = CompanyInfo.find(params[:company_id])
  #     @products = @company.products
  #   else
  #     @products = Product.all.order(:id)
  #   end
  # end



  def goods_received
    @from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : nil
    @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : nil
    @period = params[:period]
  
    @goods_received = GoodsReceived.includes(:product, :company_info).order(created_at: :desc)
    
    if @from_date && @to_date
      @goods_received = @goods_received.where(created_at: @from_date.beginning_of_day..@to_date.end_of_day)
    end
  
    # Group by company
    @goods_received_by_company = @goods_received.group_by(&:company_info)
  
    # Calculate the grand total
    @grand_total = @goods_received.sum { |g| g.product.price * g.quantity }
  
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GoodsReceivedPdf.new(@goods_received_by_company, grand_total: @grand_total, period: @period, from_date: @from_date, to_date: @to_date)
        send_data pdf.render, filename: "all_goods_received.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  
  
  

  def receive_goods
    @product = Product.find(params[:id])
    quantity_received = params[:quantity].to_f
    received_date = params[:received_date]
    company_info_id = params[:company_info_id]
  
    @product.quantity += quantity_received
  
    if @product.save
      GoodsReceived.create!(product_id: @product.id, quantity: quantity_received, received_date: received_date, company_info_id: company_info_id)
      redirect_to @product, notice: "Successfully received #{quantity_received} items."
    else
      flash.now[:alert] = "Failed to receive goods."
      render :new_receive_goods 
    end
  end

  def damage_goods
    @product = Product.find(params[:id])
    quantity = params[:product][:quantity].to_f
    damage_reason = params[:product][:damage_reason]
  
    if quantity > @product.quantity
      redirect_to @product, alert: "Not enough quantity to mark as damaged."
    else
      @product.quantity -= quantity
      if @product.save
        DamagedGood.create!(product: @product, quantity: quantity, damage_reason: damage_reason, damaged_date: Time.now)
        redirect_to @product, notice: "Successfully marked #{quantity} items as damaged."
      else
        redirect_to @product, alert: "Failed to mark goods as damaged."
      end
    end
  end
  

  def damage_goods_index
    from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : nil
    to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : nil
    @damaged_goods = DamagedGood.includes(:product).order(damaged_date: :desc)
    
    if from_date && to_date
      @damaged_goods = @damaged_goods.where(damaged_date: from_date.beginning_of_day..to_date.end_of_day)
    end
  
    respond_to do |format|
      format.html
      format.pdf do
        pdf = DamagedGoodsPdf.new(@damaged_goods, from_date, to_date)
        send_data pdf.render, filename: "damaged_goods.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end


  def general_report
    @from_date = params[:from_date].present? ? Date.parse(params[:from_date]) : nil
    @to_date = params[:to_date].present? ? Date.parse(params[:to_date]) : nil
    @period = params[:period]
  
    # Apply date filters to other scopes
    outlets_scope = Outlet.includes(:product)
    damaged_goods_scope = DamagedGood.includes(:product)
    goods_received_scope = GoodsReceived.includes(:product)
  
    if @from_date && @to_date
      outlets_scope = outlets_scope.where(created_at: @from_date.beginning_of_day..@to_date.end_of_day)
      damaged_goods_scope = damaged_goods_scope.where(damaged_date: @from_date.beginning_of_day..@to_date.end_of_day)
      goods_received_scope = goods_received_scope.where(received_date: @from_date.beginning_of_day..@to_date.end_of_day)
    end
  
    # Total physical stock calculation without date filter
    @total_physical_stock = Product.sum("quantity * price")
  
    # Apply date filters to the rest
    @total_issued_goods = outlets_scope.sum("outlets.quantity * products.price")
    @total_damaged_goods = damaged_goods_scope.sum("damaged_goods.quantity * products.price")
    @total_goods_received = goods_received_scope.sum("goods_receiveds.quantity * products.price")
  
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GeneralReportPdf.new(@total_physical_stock, @total_issued_goods, @total_damaged_goods, @total_goods_received, @period, @from_date, @to_date)
        send_data pdf.render, filename: "general_report.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  private

  def issued_products_summary_for_period(start_date, end_date, outlet_type_id)
    issued_products = Outlet.includes(:product, :outlet_type)
                            .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    
    issued_products = issued_products.where(outlet_type_id: outlet_type_id) if outlet_type_id.present?

    @issued_products_summary = issued_products.group_by(&:product).map do |product, outlets|
      total_quantity = outlets.sum(&:quantity)
      product_price = product.price
      product_unit = product.product_unit.title
      {
        product_id: product.id,
        product_name: product.product_name,
        outlet_type: outlets.first.outlet_type.name,
        total_quantity: total_quantity,
        product_price: product_price,
        product_unit: product_unit
      }
    end
  end

  
    def set_product
      @product = Product.find_by(id: params[:id])
      redirect_to products_path, alert: "Product not found." unless @product
  end

  def product_params
    params.require(:product).permit(:product_name, :price, :quantity, :company_info_id, :product_unit_id, :department_id)
  end  
end
