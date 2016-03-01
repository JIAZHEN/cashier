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
      checkout
      output = ""
      output << "***<#{COMPANY_NAME}商店>购物清单***\n".freeze
      items.each do |barcode, info|
        item = Cashier.items[barcode]
        output << "名称：#{item.name}，数量：#{info[:qty]}#{item.unit}，单价：#{info[:price]}(元)，小计：#{info[:discounted_total]}(元)"
        output << "，节省#{info[:saving]}(元)" if info[:saving]
      end

      unless promoted_items.empty?
        output << "----------------------\n".freeze
        output << "买二赠一商品：\n".freeze
        promoted_items.each do |barcode, qty|
          item = Cashier.items[barcode]
          output << "名称：#{item.name}，数量：#{info[:qty]}#{item.unit}\n"
        end
      end

      output << "----------------------\n".freeze
      output << "总计：#{total || '0.00'}(元)\n"
      output << "节省：#{savings}(元)\n" if savings > 0
      output << "**********************\n".freeze
    end
  end
end
