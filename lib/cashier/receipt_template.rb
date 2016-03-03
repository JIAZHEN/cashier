module Cashier
  class ReceiptTemplate
    attr_reader :company_name, :items, :promoted_items, :total, :savings

    def initialize(company_name, data = {})
      @company_name = company_name
      @items = data[:items] || {}
      @total = data[:total] || 0
      @savings = data[:savings] || 0
      @promoted_items = data[:promoted_items] || {}
    end

    def print
      title
      items_content
      promotions_content
      summary
    end

    private

    def format(number)
      "%.2f" % number
    end

    def title
      puts "***<#{company_name}>购物清单***".freeze
    end

    def items_content
      items.each do |_, info|
        content = "名称：#{info[:name]}，数量：#{info[:qty]}#{info[:unit]}，单价：#{format(info[:price])}(元)，小计：#{format(info[:total])}(元)"
        content << "，节省#{format(info[:saving])}(元)" if info[:saving]
        puts content
      end
    end

    def promotions_content
      unless promoted_items.empty?
        puts "----------------------".freeze
        puts "买二赠一商品：".freeze
        promoted_items.each do |barcode, qty|
          info = items[barcode]
          puts "名称：#{info[:name]}，数量：#{qty}#{info[:unit]}"
        end
      end
    end

    def summary
      puts "----------------------".freeze
      puts "总计：#{format(total)}(元)"
      puts "节省：#{format(savings)}(元)" if savings > 0
      puts "**********************".freeze
    end
  end
end
