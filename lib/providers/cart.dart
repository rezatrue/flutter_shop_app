
import 'package:flutter/foundation.dart';

class CardItem{
  String id;
  String title;
  double price;
  int quantity;

  CardItem({
    @required this.id, 
    @required this.title, 
    @required this.price, 
    @required this.quantity
    });
}

class Cart with ChangeNotifier{
  Map<String, CardItem> _items = {};


  Map<String, CardItem> get items{
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cardItem) {
      total += cardItem.price * cardItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price,){
    if(_items.containsKey(productId)){
      _items.update(productId, 
      (existingCardItem) => 
        CardItem(id: productId, title: title, price: price, quantity: existingCardItem.quantity + 1));
    }else {
      _items.putIfAbsent(productId, () => CardItem(id: DateTime.now().toString(), title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

}