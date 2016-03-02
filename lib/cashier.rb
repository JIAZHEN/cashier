require_relative "cashier/cart"
require_relative "cashier/item"
require_relative "cashier/promotion"

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
    input.reduce({}) do |result, code|
      barcode, qty = code.split("-")
      sku = result[barcode] || result[barcode] = { qty: 0, price: self.items[barcode].price }
      sku[:qty] = sku[:qty] + (qty ? qty.to_i : 1)
      sku[:total] = sku[:qty] * sku[:price]
      sku[:discounted_total] = sku[:total]
      result
    end
  end

  def self.checkout(cart)
    self.promotions.each do |promotion|
      promotion.apply_to(cart) if promotion.can_apply?(cart)
    end
    cart
  end

end
