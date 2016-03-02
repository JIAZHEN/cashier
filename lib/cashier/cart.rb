module Cashier
  class Cart
    attr_accessor :total, :items, :promoted_items, :savings

    def initialize(items = {})
      @items = items
      @promoted_items = {}
      @savings = 0
    end

    def checkout
      Cashier.promotions.each do |promotion|
        promotion.apply_to(self) if promotion.can_apply?(self)
      end
    end

    def print
      output = ""
      output << items_content
      output << promotions_content
      output << summary_content
    end

    private

    def items_content
      content = ""
      content << "***<#{COMPANY_NAME}>购物清单***\n".freeze
      items.each do |barcode, info|
        item = Cashier.items[barcode]
        content << "名称：#{item.name}，数量：#{info[:qty]}#{item.unit}，单价：#{format(info[:price])}(元)，小计：#{format(info[:discounted_total])}(元)"
        content << "，节省#{format(info[:saving])}(元)" if info[:saving]
        content << "\n".freeze
      end
      content
    end

    def promotions_content
      content = ""
      unless promoted_items.empty?
        content << "----------------------\n".freeze
        content << "买二赠一商品：\n".freeze
        promoted_items.each do |barcode, qty|
          item = Cashier.items[barcode]
          content << "名称：#{item.name}，数量：#{qty}#{item.unit}\n"
        end
      end
      content
    end

    def summary_content
      content = ""
      content << "----------------------\n".freeze
      content << "总计：#{format(total)}(元)\n"
      content << "节省：#{format(savings)}(元)\n" if savings > 0
      content << "**********************\n".freeze
    end

    def total
      items.reduce(0) { |result, (_, info)| result + info[:discounted_total] }
    end

    def format(number)
      "%.2f" % number
    end
  end
end
