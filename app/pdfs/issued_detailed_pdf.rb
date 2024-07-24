require 'prawn'
require 'prawn/table'

  class IssuedDetailedPdf < Prawn::Document
    def initialize(issued_details, period: nil, from_date: nil, to_date: nil)
      super(page_size: 'A4', top_margin: 30, bottom_margin: 30, left_margin: 20, right_margin: 20, orientation: :landscape)
      @issued_products = apply_period_filter(issued_details, period, from_date, to_date)
      @period = period
      @from_date = from_date
      @to_date = to_date
      @company_detail = CompanyDetail.first
      header
      company_table
     
    end
  
    def apply_period_filter(issued_details,  period, from_date, to_date)
      return issued_details unless period && from_date && to_date
  
      from_date = from_date.to_date
      to_date = to_date.to_date
  
      case period
      when "day"
        issued_details.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
      when "month"
        issued_details.where(created_at: from_date.beginning_of_month..to_date.end_of_month)
      when "year"
        issued_details.where(created_at: from_date.beginning_of_year..to_date.end_of_year)
      else
        issued_details
      end
    end

    def header
      if @company_detail
        text @company_detail.name, size: 20, style: :bold, align: :center
        text @company_detail.address1, size: 12, align: :center
        text @company_detail.address2, size: 12, align: :center
        # text @company_detail.address3, size: 12, align: :center
        # text "Website: #{@company_detail.website}", size: 12, align: :center
        # text "Telephone: #{@company_detail.telephone_number}", size: 12, align: :center
        # text "TIN: #{@company_detail.tin_number}", size: 12, align: :center
       
      end
      move_down 10
      text "Issued  Details Report", size: 14, style: :bold, align: :center
      move_down 10
      stroke_horizontal_rule
      move_down 2
      stroke_horizontal_rule
      move_down 10
    end

 
  def company_table
    table company_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.cell_style = { padding: [6, 8, 6, 8], border_width: 0 }
      self.column_widths = [30, 90, 80, 80, 75, 70,130] 
    end
  end

  def company_rows
    rows = [["ID", "Item Name","Outlet" ,"Unit", "Quantity", "Price","Supplier"]] +
              @issued_products.map do |issued_product|
             [
                issued_product.product.id,
                issued_product.product.product_name,
                issued_product.outlet_type.name,
                issued_product.product.product_unit.title,
                issued_product.quantity,
                issued_product.product.price*issued_product.quantity,
                issued_product.product.company_info.company_name
               
             ]
           end
  end

  def format_date(date)
    date.strftime("%Y-%m-%d")
  end

  def footer
    repeat(:all) do
      bounding_box([bounds.left, bounds.bottom + 30], width: bounds.width) do
        stroke_horizontal_rule
        move_down 2
        stroke_horizontal_rule
        move_down 3
        text "Page #{page_number}", size: 10, align: :center
        text "Powered By: Be-Konnect", size: 6, align: :center
      end
    end
  end

  def truncate(text, options = {})
    length = options.fetch(:length, 30)
    if text.length > length
      text[0...length] + '...'
    else
      text
    end
  end

  def format_currency(amount)
    "UGX " + ActionController::Base.helpers.number_to_currency(amount, precision: 2, unit: "")
  end

end
