import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
        value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders()),
      ], 
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailedScreen.routeName : (ctx) => ProductDetailedScreen(),
          CartScreen.routeName : (ctx) => CartScreen(),
          OrdersScreen.routeName : (ctx) => OrdersScreen(),
          UserProductsScreen.routeName : (ctx) => UserProductsScreen(),
          EditProductScreen.routeName : (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

