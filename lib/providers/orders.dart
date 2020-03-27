import 'package:flutter/foundation.dart';
import './cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id, 
    @required this.amount, 
    @required this.products, 
    @required this.dateTime
    });

}

class Orders with ChangeNotifier{

  String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://myshop-59cad.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    //print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null) return;
    extractedData.forEach((orderId, orderData){
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
        .map((item) => CartItem(
          id: item['id'], 
          title: item['title'], 
          price: item['price'], 
          quantity: item['quantity'],)
        ).toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder (List<CartItem> cartProducts, double total) async {

    final url = 'https://myshop-59cad.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url, body: json.encode({
      'amount' : total,
      'dateTime' : timeStamp.toIso8601String(),
      'products' : cartProducts.map((cp) => {
        'id': cp.id,
        'title' : cp.title,
        'price' : cp.price,
        'quantity' : cp.quantity
      }).toList(),
    }),);

    _orders.insert(
      0, OrderItem(
        id: json.decode(response.body)['name'], 
        amount: total, 
        dateTime: timeStamp, 
        products: cartProducts), 
      );

    notifyListeners();
  }

}