class OrdersController < ApplicationController
  require 'receipts'
  require 'prawn/measurement_extensions'
  
  include ActionView::Helpers::NumberHelper

  def index
    @orders = Order.all
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @orders = @orders.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    end

    @total_sales = @orders.sum { |order| order.total_price || 0.0 }
  end

  def show
    @order = Order.find(params[:id])
    @order.calculate_total_amount unless @order.total_price # Ensure total_price is calculated if nil
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Order not found"
    redirect_to root_path
  end

  def new
    @order = Order.new
    @product_details = ProductDetail.all.includes(:category)  # Assuming you have a category association
    @categories = Category.all
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      @product_details = ProductDetail.all.includes(:category)
      @categories = Category.all
      render :new
    end
  end

  def receipt
    @order = Order.find_by(id: params[:id])
    unless @order
      flash[:alert] = "Order not found"
      redirect_to root_path
      return
    end

    @order.calculate_total_amount unless @order.total_price

    @company_detail = CompanyDetail.first 

    pdf = Prawn::Document.new(
      page_size: [80.mm, 230.mm],
      page_layout: :portrait,
      margin: 5.mm
    )

    pdf.font_size 10

    logo_path = Rails.root.join('app', 'assets', 'images', 'logo.png')
    logo_width = 120
    logo_position_x = (pdf.bounds.width - logo_width) / 2
    pdf.image logo_path, at: [logo_position_x, pdf.bounds.top], width: logo_width

    pdf.move_down 80

    pdf.text @company_detail&.name, size: 14, style: :bold, align: :center
    pdf.text @company_detail&.address1, size: 10, align: :center,style: :bold
    pdf.text @company_detail&.address2, size: 9, align: :center, style: :bold
    pdf.text @company_detail&.address3, size: 9, align: :center, style: :bold
    pdf.move_down 4
    pdf.stroke_horizontal_rule
    pdf.move_down 2
    pdf.stroke_horizontal_rule
    pdf.move_down 10

    pdf.text "Date : #{formatted_date(@order.created_at)}                                Bill No: #{@order.id}", size: 8, style: :bold, align: :left
    pdf.text "Receipt", size: 12, style: :bold, align: :center
    pdf.move_down 10

    pdf.table receipt_items, header: true, cell_style: { padding: 4, border_width: 0.9 } do
      row(0).font_style = :bold
      self.width = pdf.bounds.width
      self.cell_style = { padding: [6, 6, 6, 6], border_width: 0.6 }
      self.column_widths = [pdf.bounds.width * 0.26, pdf.bounds.width * 0.24, pdf.bounds.width * 0.19, pdf.bounds.width * 0.31] # Adjust widths as needed
      self.cells.borders = [:bottom]
    end

    pdf.move_down 10
    pdf.text "Thank you for your business!", size: 10, align: :center
    pdf.text "Powered By Be-Konnect!", size: 6, align: :center
    pdf.text "Mob: +256783365384 for support!", size: 6, align: :center

    send_data pdf.render, filename: "receipt_#{@order.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:product_detail_id, :quantity, :_destroy])
  end

  def format_currency(amount)
    number_to_currency(amount, unit: "", precision: 2)
  end

  def receipt_items
    items = [["Item", "Rate", "Qty", "Amount"]]

    @order.order_items.each do |item|
      items << [
        item.product_detail.name,
        item.product_detail.price,
        item.quantity,
        format_currency(item.quantity * item.product_detail.price)
      ]
    end

    subtotal = @order.total_price
    tax = subtotal* 0.18
    total= (subtotal)

    items += [
      ["", "", "Sub total", format_currency(subtotal-tax)],
      ["", "", "Tax (18%)", format_currency(tax)],
      ["", "", "Total", format_currency(total)] 
    ]
    
    items
  end

  def formatted_date(date)
    date.strftime("%Y-%m-%d")
  end
end
