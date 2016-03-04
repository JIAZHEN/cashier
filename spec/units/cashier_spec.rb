require "spec_helper"

describe "Cashier" do
  before do
    Cashier.items = {
      "ITEM000001" => Cashier::Item.new(name: "羽毛球", unit: "个", price: 1, type: "体育", barcode: "ITEM000001"),
      "ITEM000003" => Cashier::Item.new(name: "苹果", unit: "斤", price: 5.5, type: "水果", barcode: "ITEM000003"),
      "ITEM000005" => Cashier::Item.new(name: "可口可乐", unit: "瓶", price: 3, type: "饮料", barcode: "ITEM000005")
    }
  end

  context ".checkout" do
    context "when input is not given" do
      let(:empty_data) {{
        items: {},
        promoted_items: {},
        total: 0,
        savings: 0
      }}

      it "returns empty data" do
        expect(Cashier.checkout).to eq empty_data
      end
    end

    context "with items" do
      let(:input) { ["ITEM000001", "ITEM000001", "ITEM000003-3", "ITEM000005"] }
      let(:items) {{
        "ITEM000001" => { name: "羽毛球", unit: "个", qty: 2, price: 1, total: 2 },
        "ITEM000003" => { name: "苹果", unit: "斤", qty: 3, price: 5.5, total: 16.5 },
        "ITEM000005" => { name: "可口可乐", unit: "瓶", qty: 1, price: 3, total: 3 }
      }}
      let(:promoted_items) { {} }
      let(:total) { 21.5 }
      let(:savings) { 0.0 }
      let(:data) {{ items: items, promoted_items: promoted_items, total: total, savings: savings }}

      context "and no promotion" do
        it "returns correct data" do
          expect(Cashier.checkout(input)).to eq data
        end
      end

      context "and with promotions" do
        let(:input) { ["ITEM000001", "ITEM000001", "ITEM000001", "ITEM000001", "ITEM000001", "ITEM000003-3", "ITEM000005"] }
        let(:items) {{
          "ITEM000001" => { name: "羽毛球", unit: "个", qty: 5, price: 1, total: 4 },
          "ITEM000003" => { name: "苹果", unit: "斤", qty: 3, price: 5.5, total: 15.674999999999999, saving: 0.8250000000000001 },
          "ITEM000005" => { name: "可口可乐", unit: "瓶", qty: 1, price: 3, total: 3 }
        }}
        let(:promoted_items) { { "ITEM000001" => 1 } }
        let(:total) { 22.675 }
        let(:savings) { 1.8250000000000001 }
        let(:promotions) {
          [
            Cashier::Promotion.new(barcode: "ITEM000001", qty: 3) do |info, promoted_items, promotion|
              promoted_items[promotion.barcode] = info[:qty] / promotion.qty
              info[:total] = info[:price] * (info[:qty] - info[:qty] / promotion.qty)
            end,

            Cashier::Promotion.new(barcode: "ITEM000003", qty: 1) do |info, promoted_items, promotion|
              info[:total] = info[:price] * info[:qty] * 0.95
              info[:saving] = info[:price] * info[:qty] * 0.05
            end
          ]
        }

        before { Cashier.promotions = promotions }

        it "returns correct data" do
          expect(Cashier.checkout(input)).to eq data
        end
      end

      context "and one product has two promotions" do
        let(:items) {{
          "ITEM000001" => { name: "羽毛球", unit: "个", qty: 2, price: 1, total: 1.9, saving: 0.1 },
          "ITEM000003" => { name: "苹果", unit: "斤", qty: 3, price: 5.5, total: 16.5 },
          "ITEM000005" => { name: "可口可乐", unit: "瓶", qty: 1, price: 3, total: 3 }
        }}
        let(:promoted_items) { {} }
        let(:total) { 21.4 }
        let(:savings) { 0.1 }
        let(:promotions) {
          [
            Cashier::Promotion.new(barcode: "ITEM000001", qty: 1) do |info, promoted_items, promotion|
              info[:total] = info[:price] * info[:qty] * 0.95
              info[:saving] = info[:price] * info[:qty] * 0.05
            end,

            Cashier::Promotion.new(barcode: "ITEM000001", qty: 3) do |info, promoted_items, promotion|
              promoted_items[promotion.barcode] = info[:qty] / promotion.qty
              info[:total] = info[:price] * (info[:qty] - info[:qty] / promotion.qty)
            end
          ]
        }

        before { Cashier.promotions = promotions }

        it "uses the first matched promotion" do
          expect(Cashier.checkout(input)).to eq data
        end
      end
    end
  end
end
