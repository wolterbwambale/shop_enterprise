require 'prawn'
require 'prawn/table'

class CompanyPdf < Prawn::Document
  def initialize(companies)
    super(page_size: 'A4', top_margin: 50, bottom_margin: 50, left_margin: 20, right_margin: 20, orientation: :landscape)
    @company_infos = companies
    @company_detail = CompanyDetail.first
    header
    company_table
    footer
  end

  def header
    if @company_detail
      text @company_detail.name, size: 24, style: :bold, align: :center
      text @company_detail.address1, size: 12, align: :center
      text @company_detail.address2, size: 12, align: :center
      # text @company_detail.address3, size: 12, align: :center
      # text "Website: #{@company_detail.website}", size: 12, align: :center
      # text "Telephone: #{@company_detail.telephone_number}", size: 12, align: :center
      # text "TIN: #{@company_detail.tin_number}", size: 12, align: :center
    end
    move_down 10
    text "List of suppliers", size: 16, style: :bold, align: :center
    move_down 2
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
      self.cell_style = { padding: [6, 8, 6, 8], border_width: 0.2 }
      self.column_widths = [30, 90, 65, 70, 75, 80,  60, 85] 
    end
  end

  def company_rows
    rows = [["ID", "Company Name","Address" ,"Physical Address", "Website", "Telephone", "P.O.Box","Tin"]] +
           @company_infos.map do |company|
             [
               company.id,
               truncate(company.company_name.capitalize, length: 30),
               company.address,
               company.physical_address,
               company.website,
               company.telephone,
               company.postal_box,
               company.Tin_number
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
        text "Thank you for supporting Be-Konnect", size: 6, align: :center
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
