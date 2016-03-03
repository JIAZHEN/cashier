require_relative "cashier/item"
require_relative "cashier/promotion"
require_relative "cashier/receipt_template"

module Cashier

  COMPANY_NAME = "My Shop"

  def self.items=(items)
    @items = items
  end

  def self.items
    @items
  end

  def self.promotions=(promotions)
    @promotions = promotions
  end

  def self.promotions
    @promotions
  end

  def self.scan(input = [])
    input.reduce({}) do |data, code|
      barcode, qty = code.split("-")
      item = self.items[barcode]
      info = data[barcode] || data[barcode] = { qty: 0, price: item.price, name: item.name, total: 0 }
      info[:qty] = info[:qty] + (qty ? qty.to_i : 1)
      info[:total] = info[:qty] * info[:price]
      data
    end
  end

  def self.sum(data, promoted_items)
    data.reduce({ total: 0, savings: 0}) do |result, (barcode, info)|
      result[:total] = result[:total] +
        (info[:qty] - (promoted_items[barcode][:qty] || 0)) * info[:price] -
        (info[:saving] || 0)

      result[:savings] = result[:savings] +
        (promoted_items[barcode][:qty] || 0) * info[:price] +
        (info[:saving] || 0)
      result
    end
  end

  def self.checkout(input = [])
    data, promoted_items = self.scan(input), {}

    data.each do |barcode, info|
      promotion = self.promotions.detect { |p| p.can_apply?(info) }
      promotion.apply_to(info, promoted_items) if promotion
    end

    summary = self.sum(data, promoted_items)
    { items: data, promoted_items: promoted_items }.merge(summary)
  end

end
