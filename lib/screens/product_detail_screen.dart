import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailedScreen extends StatelessWidget {
// final String title;

// ProductDetailedScreen(this.title);

static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findByid(productId);
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title)),
      
    );
  }
}