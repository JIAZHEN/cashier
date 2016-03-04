# cashier

To build a cashier system that can take input and print out the receipt.
The system can be configurated to have any discounts or promotions.

# Setup
Checkout the repository then run
```
bundle install
```

# Run the example
Run `ruby examples/cashier_with_promotions.rb` should output

```

\*\*\*<JZ's Shop>购物清单\*\*\*

名称: 可口可乐，数量：3瓶，单价：3.00(元)，小计：6.00(元\)

名称：羽毛球，数量：6个，单价：1.00(元)，小计：4.00(元)

名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)

----------------------
买二赠一商品：

名称：可口可乐，数量：1瓶

名称：羽毛球，数量：2个

----------------------
总计：20.45(元)

节省：5.55(元)

```
