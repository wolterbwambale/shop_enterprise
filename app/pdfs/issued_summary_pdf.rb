require 'prawn'
require 'prawn/table'

class IssuedSummaryPdf < Prawn::Document
  def initialize(issued_summaries, period: nil, from_date: nil, to_date: nil, outlet_type: nil)
    super(page_size: 'A4', top_margin: 30, bottom_margin: 30, left_margin: 20, right_margin: 20, orientation: :landscape)
    @issued_products_summary = issued_summaries
    @company_detail = CompanyDetail.first
    @period = period
    @from_date = from_date
    @to_date = to_date
    @outlet_type = outlet_type

    header
    company_table
    footer
  end

  def header
    if @company_detail
      text @company_detail.name, size: 24, style: :bold, align: :center
      text @company_detail.address1, size: 12, align: :center
      text @company_detail.address2, size: 12, align: :center
    end

    move_down 10
    text "Issued Summary Report", size: 14, style: :bold, align: :center
    text "Period: #{@period} From: #{@from_date} To: #{@to_date} Outlet: #{@outlet_type&.name}", size: 12, align: :center
    move_down 4
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
      self.cell_style = { padding: [6, 6, 6, 6], border_width: 0.9 }
      self.cells.borders = [:bottom]
      self.column_widths = [50, 100, 60, 80, 70, 65, 130]
    end
  end

  def company_rows
    rows = [["Code", "Item Name", "Unit", "Outlet", "Quantity", "Price", "Amount"]] +
           @issued_products_summary.map do |issued_summary|
             [
               issued_summary[:product_id],
               issued_summary[:product_name],
               issued_summary[:product_unit],
               issued_summary[:outlet_type],
               issued_summary[:total_quantity],
               issued_summary[:product_price],
               format_currency(issued_summary[:total_quantity] * issued_summary[:product_price])
             ]
           end
    rows << ["", "Grand Total:", "", "", "", "", format_currency(calculate_grand_total)].map { |item| { content: item, font_style: :bold } }
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

  def calculate_grand_total
    @issued_products_summary.sum { |issued_summary| issued_summary[:total_quantity] * issued_summary[:product_price] }
  end

  def format_currency(amount)
    "UGX " + ActionController::Base.helpers.number_to_currency(amount, precision: 2, unit: "")
  end
end
