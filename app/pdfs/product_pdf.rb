require 'prawn'
require 'prawn/table'

class ProductPdf < Prawn::Document
  def initialize(products, grand_total, period: nil, from_date: nil, to_date: nil, department_id: nil)
    super(page_size: 'A4', top_margin: 30, bottom_margin: 30, left_margin: 20, right_margin: 20, orientation: :portrait)
    @products = apply_filters(products, period, from_date, to_date, department_id)
    @grand_total = grand_total
    @period = period
    @from_date = from_date
    @to_date = to_date
    @department = Department.find(department_id) if department_id.present?
    @company_detail = CompanyDetail.first
    header
    product_table
    footer
  end

  def apply_filters(products, period, from_date, to_date, department_id)
    products = apply_period_filter(products, period, from_date, to_date)
    products = apply_department_filter(products, department_id)
    products
  end

  def apply_period_filter(products, period, from_date, to_date)
    return products unless period && from_date && to_date

    from_date = from_date.to_date
    to_date = to_date.to_date

    case period
    when "day"
      products.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
    when "month"
      products.where(created_at: from_date.beginning_of_month..to_date.end_of_month)
    when "year"
      products.where(created_at: from_date.beginning_of_year..to_date.end_of_year)
    else
      products
    end
  end

  def apply_department_filter(products, department_id)
    return products unless department_id.present?

    products.where(department_id: department_id)
  end

  def header
    if @company_detail
      text @company_detail.name, size: 24, style: :bold, align: :center
      text @company_detail.address1, size: 12, align: :center
      text @company_detail.address2, size: 12, align: :center
    end

    move_down 10
    text "Physical Stock Report", size: 14, style: :bold, align: :center
    move_down 4
    stroke_horizontal_rule
    move_down 2
    stroke_horizontal_rule
    move_down 10
    if @period && @from_date && @to_date
      text "Dates: #{@period.capitalize} From (#{@from_date} to #{@to_date})", size: 12, align: :center
      move_down 5
    end
    if @department
      text "Department: #{@department.department_name}", size: 12, align: :center
      move_down 5
    end
  end

  def product_table
    table product_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.cell_style = { padding: [6, 8, 6, 8], border_width: 0.9 }
      self.column_widths = [40, 80, 60, 70, 100, 120, 85]
    end
  end

  def product_rows
    rows = [["ID", "Product Name", "Unit", "Quantity", "Price", "Total Amount", "Department"]] +
           @products.map do |product|
             [
               product.id,
               truncate(product.product_name.capitalize, length: 30),
               product.product_unit.title,
               product.quantity,
               format_currency(product.price),
               format_total_amount(product.price * product.quantity),
               product.department&.department_name
             ]
           end
    rows << ["", "Grand Total:", "", "", "", format_currency(@grand_total), ""].map { |item| { content: item, font_style: :bold } }
  end

  def format_currency(amount)
    "UGX " + ActionController::Base.helpers.number_to_currency(amount, precision: 2, unit: "")
  end

  def format_total_amount(amount)
    "UGX " + ActionController::Base.helpers.number_to_currency(amount, precision: 2, delimiter: ',', separator: '.', unit: "")
  end

  def truncate(text, options = {})
    length = options.fetch(:length, 30)
    if text.length > length
      text[0...length] + '...'
    else
      text
    end
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
        text "contact for support: 0783365384", size: 6, align: :center
      end
    end
  end
end
