require_relative "../lib/cashier"
require "spec_helper"

describe Cashier::Cart do
  let(:cart) { described_class.new }
  let(:db_items) {{
    "ITEM000001" => Cashier::Item.new(name: "羽毛球", unit: "个", price: 1, type: "体育", barcode: "ITEM000001"),
    "ITEM000003" => Cashier::Item.new(name: "苹果", unit: "斤", price: 5.5, type: "水果", barcode: "ITEM000003"),
    "ITEM000005" => Cashier::Item.new(name: "可口可乐", unit: "瓶", price: 3, type: "饮料", barcode: "ITEM000005")
  }}

  before { Cashier.items = db_items }

  context "#print" do
    context "when cart is empty" do
      let(:receipt_for_empty) do
<<-eos
***<My Shop>购物清单***
----------------------
总计：0.00(元)
**********************
eos
      end

      it "prints the receipt for empty" do
        expect(cart.print).to eq receipt_for_empty
      end
    end

    context "when cart has items but no promotions" do
      let(:receipt) do
<<-eos
***<My Shop>购物清单***
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：11.00(元)
----------------------
总计：25.00(元)
**********************
eos
      end
      let(:cart_items) {{
        "ITEM000005" => { qty: 3, price: 3, discounted_total: 9 },
        "ITEM000001" => { qty: 5, price: 1, discounted_total: 5 },
        "ITEM000003" => { qty: 2, price: 5.5, discounted_total: 11 }
      }}
      let(:cart) { described_class.new(cart_items) }

      it "prints the right receipt" do
        expect(cart.print).to eq receipt
      end
    end

    context "when cart has items with 5% off discount" do
      let(:receipt) do
<<-eos
***<My Shop>购物清单***
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
----------------------
总计：24.45(元)
节省：0.55(元)
**********************
eos
      end
      let(:cart_items) {{
        "ITEM000005" => { qty: 3, price: 3, discounted_total: 9 },
        "ITEM000001" => { qty: 5, price: 1, discounted_total: 5 },
        "ITEM000003" => { qty: 2, price: 5.5, discounted_total: 10.45, saving: 0.55 }
      }}
      let(:cart) { described_class.new(cart_items) }

      before { cart.savings = 0.55 }

      it "prints the right receipt" do
        expect(cart.print).to eq receipt
      end
    end

    context "when cart has items with 5% off discount and 3 for 2 promotion" do
      let(:receipt) do
<<-eos
***<My Shop>购物清单***
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：6.00(元)
名称：羽毛球，数量：6个，单价：1.00(元)，小计：4.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
----------------------
买二赠一商品：
名称：可口可乐，数量：1瓶
名称：羽毛球，数量：2个
----------------------
总计：20.45(元)
节省：5.55(元)
**********************
eos
      end
      let(:cart_items) {{
        "ITEM000005" => { qty: 3, price: 3, discounted_total: 6 },
        "ITEM000001" => { qty: 6, price: 1, discounted_total: 4 },
        "ITEM000003" => { qty: 2, price: 5.5, discounted_total: 10.45, saving: 0.55 }
      }}
      let(:cart) { described_class.new(cart_items) }

      before do
        cart.savings = 5.55
        cart.promoted_items = { "ITEM000005" => 1, "ITEM000001" => 2 }
      end

      it "prints the right receipt" do
        expect(cart.print).to eq receipt
      end
    end
  end
end
