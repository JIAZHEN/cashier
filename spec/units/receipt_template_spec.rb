require "spec_helper"

describe Cashier::ReceiptTemplate do
  let(:company_name) { "JZ's Shop" }
  let(:data) { {} }
  let(:template) { described_class.new(company_name, data) }

  context "#print" do
    context "when cart is empty" do
      let(:receipt_for_empty) do
<<-eos
***<JZ's Shop>购物清单***
----------------------
总计：0.00(元)
**********************
eos
      end

      it "prints the receipt for empty" do
        expect{ template.print }.to output(receipt_for_empty).to_stdout
      end
    end

    context "when cart has items but no promotions" do
      let(:receipt) do
<<-eos
***<JZ's Shop>购物清单***
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：11.00(元)
----------------------
总计：25.00(元)
**********************
eos
      end
      let(:data) {{
        items: {
          "ITEM000005" => { name: "可口可乐", unit: "瓶", qty: 3, price: 3, total: 9 },
          "ITEM000001" => { name: "羽毛球", unit: "个", qty: 5, price: 1, total: 5 },
          "ITEM000003" => { name: "苹果", unit: "斤", qty: 2, price: 5.5, total: 11 }
        },
        total: 25
      }}

      it "prints the right receipt" do
        expect{ template.print }.to output(receipt).to_stdout
      end
    end

    context "when cart has items with 5% off discount" do
      let(:receipt) do
<<-eos
***<JZ's Shop>购物清单***
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
----------------------
总计：24.45(元)
节省：0.55(元)
**********************
eos
      end
      let(:data) {{
        items: {
          "ITEM000005" => { name: "可口可乐", unit: "瓶", qty: 3, price: 3, total: 9 },
          "ITEM000001" => { name: "羽毛球", unit: "个", qty: 5, price: 1, total: 5 },
          "ITEM000003" => { name: "苹果", unit: "斤", qty: 2, price: 5.5, total: 10.45, saving: 0.55 }
        },
        total: 24.45,
        savings: 0.55
      }}

      it "prints the right receipt" do
        expect{ template.print }.to output(receipt).to_stdout
      end
    end

    context "when cart has items with 5% off discount and 3 for 2 promotion" do
      let(:receipt) do
<<-eos
***<JZ's Shop>购物清单***
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
      let(:data) {{
        items: {
          "ITEM000005" => { name: "可口可乐", unit: "瓶", qty: 3, price: 3, total: 6 },
          "ITEM000001" => { name: "羽毛球", unit: "个", qty: 6, price: 1, total: 4 },
          "ITEM000003" => { name: "苹果", unit: "斤", qty: 2, price: 5.5, total: 10.45, saving: 0.55 }
        },
        promoted_items: { "ITEM000005" => 1, "ITEM000001" => 2 },
        total: 20.45,
        savings:5.55
      }}

      it "prints the right receipt" do
        expect{ template.print }.to output(receipt).to_stdout
      end
    end
  end
end
