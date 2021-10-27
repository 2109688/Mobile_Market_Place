import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:market_place/Checkout.dart';
import 'package:market_place/Providers.dart';
import 'package:market_place/widgets/CartItem.dart';

import 'package:market_place/HTTP.dart';

final double padding = 8.0;

final lightGrey = Color(0xFFA0A0A0);
final darkGrey = Color(0xFF535353);

final lightYellow = Color(0xFFDFC598);
final darkYellow = Color(0xFFCEA661);

final currencyFormat = new NumberFormat("#,##0.00", "en_US");

class Cart extends StatefulWidget {
  const Cart({
    Key key,
  }) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    double contextHeight = MediaQuery.of(context).size.height;
    double iconHeight = contextHeight * 0.18;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          backgroundColor: darkYellow,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: padding, top: padding, right: padding),
          child: Consumer(builder: (context, watch, child) {
            final _cart = watch(cartProvider).cart;
            final _price = watch(cartProvider).price;

            return ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (BuildContext context, int index) => Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    int productID = _cart[index];

                    final _quantity = context.read(quantityProvider).quantity;
                    double quantity = _quantity[productID];
                    double price = _price[productID] * quantity;

                    double total = context.read(totalProvider).total;
                    total -= price;

                    double count = context.read(countProvider).count;
                    count -= quantity;

                    DeleteFromCart().deleteFromCart(productID);

                    showDialog(
                      // display dialog "product added!"
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: new Text("Product deleted!"),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    ChangeTotalAndCount().changeTotalAndCount(total, count);

                    context.read(totalProvider).removeFromTotal(price);
                    context.read(countProvider).removeFromCount(quantity);
                    context.read(cartProvider).removeFromCart(productID);
                    context.read(quantityProvider).removeQuantity(productID);
                  },
                  child: new CartItem(productID: _cart[index])),
            );
          }),
        ),
        persistentFooterButtons: [
          Column(
            children: [
              Container(
                height: iconHeight / 2.65,
                child: Column(
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Total:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Consumer(
                          builder: (context, watch, child) {
                            final _total = watch(totalProvider).total;
                            return Container(
                              child: RichText(
                                text: TextSpan(
                                  text: "R" + currencyFormat.format(_total),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Consumer(builder: (context, watch, child) {
                      final _count = watch(countProvider).count;

                      return Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            text: "(" + _count.round().toString() + " Items)",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: darkYellow,
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout()),
                    );
                  },
                  child: const Text('Checkout'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
