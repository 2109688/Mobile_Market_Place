import 'package:flutter_test/flutter_test.dart';
import 'package:market_place/widgets/product-widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets(
      'The product Widget should have an image, name, price and quantity',
      (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new Product(
                name: "Name", price: 10, description: "", quantity: 15)));
    await tester.pumpWidget(testWidget);
  });
}
