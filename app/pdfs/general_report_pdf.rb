class GeneralReportPdf < Prawn::Document
  def initialize(total_physical_stock, total_issued_goods, total_damaged_goods, total_goods_received, period, from_date, to_date)
    super(top_margin: 70)
    @total_physical_stock = total_physical_stock
    @total_issued_goods = total_issued_goods
    @total_damaged_goods = total_damaged_goods
    @total_goods_received = total_goods_received
    @period = period
    @from_date = from_date
    @to_date = to_date
    @company_detail = CompanyDetail.first
    header
    display_general_report
    display_grand_totals
  end

  def header
    if @company_detail
      text @company_detail.name, size: 20, style: :bold, align: :center
      text @company_detail.address1, size: 12, align: :center
      text @company_detail.address2, size: 12, align: :center
      move_down 10
    end
    text "General Report", size: 18, style: :bold
    move_down 5
    text "Period: #{@period}", size: 15 if @period
    text "From: #{@from_date}" if @from_date
    text "To: #{@to_date}" if @to_date
    move_down 10
  end

  def display_general_report
    move_down 20
    table(general_report_table, header: true, width: bounds.width) do
      row(0).font_style = :bold
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.cell_style = { padding: 8 }
    end
  end

  def general_report_table
    [
      ["Metric", "Amount (in UGX)"],
      ["Total Physical Stock", format_total_amount(@total_physical_stock)],
      ["Total Issued Goods", format_total_amount(@total_issued_goods)],
      ["Total Damaged Goods", format_total_amount(@total_damaged_goods)],
      ["Total Goods Received", format_total_amount(@total_goods_received)]
    ]
  end

  def display_grand_totals
    move_down 10
    text "Grand Totals", size: 14, style: :bold
    text "Total Physical Stock: #{format_total_amount(@total_physical_stock)}", size: 12
    text "Total Issued Goods: #{format_total_amount(@total_issued_goods)}", size: 12
    text "Total Damaged Goods: #{format_total_amount(@total_damaged_goods)}", size: 12
    text "Total Goods Received: #{format_total_amount(@total_goods_received)}", size: 12
  end

  def format_total_amount(amount)
    "UGX " + ActionController::Base.helpers.number_to_currency(amount, precision: 2, delimiter: ',', separator: '.', unit: "")
  end
end
