class DamagedGoodsPdf < Prawn::Document
    def initialize(damaged_goods, from_date = nil, to_date = nil)
      super(top_margin: 70)
      @damaged_goods = damaged_goods
      @from_date = from_date
      @to_date = to_date
      @company_detail =CompanyDetail.first
      header
      text_content
      table_content
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
            move_down 10
      if @from_date && @to_date
        text "From #{@from_date} to #{@to_date}", size: 12, style: :italic
      end
    end
end
  
    def text_content
      move_down 20
      text "This report shows the history of damaged goods within the specified period.", size: 12
      move_down 10
    end
  
    def table_content
      move_down 20
      table damaged_goods_rows do
        row(0).font_style = :bold
        columns(1..3).align = :right
        self.row_colors = ["DDDDDD", "FFFFFF"]
        self.header = true
      end
      move_down 10
      text "Grand Total: #{ActionController::Base.helpers.number_with_delimiter(sprintf('%.2f', grand_total))}", size: 12, style: :bold
    end
  
    def damaged_goods_rows
      [["Date Damaged", "Product Name", "Quantity Damaged", "Rate", "Total Cost", "Reason"]] +
      @damaged_goods.map do |damaged_good|
        total_cost = damaged_good.product.price * damaged_good.quantity
        [
          damaged_good.damaged_date.strftime("%Y-%m-%d"),
          damaged_good.product.product_name,
          damaged_good.quantity,
          ActionController::Base.helpers.number_with_delimiter(sprintf('%.2f', damaged_good.product.price)),
          ActionController::Base.helpers.number_with_delimiter(sprintf('%.2f', total_cost)),
          damaged_good.damage_reason
        ]
      end
    end
  
    def grand_total
      @damaged_goods.inject(0) do |sum, damaged_good|
        sum + (damaged_good.product.price * damaged_good.quantity)
      end
    end
  end
  