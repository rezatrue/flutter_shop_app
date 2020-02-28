import 'package:flutter/material.dart';


class ProductDetailedScreen extends StatelessWidget {
// final String title;

// ProductDetailedScreen(this.title);

static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text(productId)),
      
    );
  }
}