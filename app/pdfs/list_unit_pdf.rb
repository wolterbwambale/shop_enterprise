class ListUnitPdf < Prawn::Document
  def initialize(product_units)
    super(page_size: 'A4', top_margin: 30, bottom_margin: 30, left_margin: 20, right_margin: 20, orientation: :landscape)
    @product_units = product_units
    @company_detail=CompanyDetail.first
    header
    product_unit_table
    footer
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
    text "List of Units", size: 15, style: :bold, align: :center
    move_down 4
    stroke_horizontal_rule
    move_down 2
    stroke_horizontal_rule
    move_down 10
  end

 
  def product_unit_table
    table product_unit_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.cell_style = { padding: [6, 8, 6, 8], border_width: 0.7 }
      self.column_widths = [150, 150, 255] 
    end
  end

  def product_unit_rows
    rows = [["Code", "Unit Name","Description"]] +
           @product_units.map do |product_unit|
             [
               product_unit.code.capitalize,
               product_unit.title.capitalize,
               truncate(product_unit.description.capitalize, length: 80)
               
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

end
