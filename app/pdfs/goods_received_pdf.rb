class GoodsReceivedPdf < Prawn::Document
  def initialize(goods_received_by_company, grand_total:, period: nil, from_date: nil, to_date: nil)
    super(top_margin: 70)
    @goods_received_by_company = goods_received_by_company
    @grand_total = grand_total
    @period = period
    @from_date = from_date
    @to_date = to_date
    @company_detail = CompanyDetail.first
    header
    display_goods_received
    display_grand_total
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
    text "Goods Received Report", size: 18, style: :bold
    move_down 5
    text "Period: #{@period}", size: 15
    text "From: #{@from_date}" if @from_date
    text "To: #{@to_date}" if @to_date
  end

  def display_goods_received
    @goods_received_by_company.each do |company, goods_received|
      text "Company: #{company.company_name}", size: 16, style: :bold
      move_down 10
      table goods_received_table(goods_received), width: bounds.width do
        row(0).font_style = :bold
        self.header = true
        self.row_colors = ["DDDDDD", "FFFFFF"]
      end
      move_down 20
    end
  end

  def goods_received_table(goods_received)
    [["Date Received", "Product Name", "Quantity", "Rate", "Total Cost"]] +
      goods_received.map do |goods|
        total_cost = goods.product.price * goods.quantity
        [
          goods.created_at.strftime("%Y-%m-%d"),
          goods.product.product_name,
          goods.quantity,
          sprintf("%.2f", goods.product.price),
          sprintf("%.2f", total_cost)
        ]
      end +
      [["", "", "", "Company Total", sprintf("%.2f", goods_received.sum { |g| g.product.price * g.quantity })]]
  end

  def display_grand_total
    move_down 20
    text "Grand Total: #{@grand_total}", size: 15, style: :bold
  end
end
