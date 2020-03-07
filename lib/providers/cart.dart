
import 'package:flutter/foundation.dart';

class CartItem{
  String id;
  //String productId;
  String title;
  double price;
  int quantity;

  CartItem({
    @required this.id,
    //@required this.productId, 
    @required this.title, 
    @required this.price, 
    @required this.quantity
    });
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _items = {};


  Map<String, CartItem> get items{
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

  void removeItem(String productId){
    if(productId != null){
      _items.removeWhere((_, item) => item.id == productId );
    }
    //_items.remove(productId);
    notifyListeners();
  }

  void addItem(String productId, String title, double price,){
    if(_items.containsKey(productId)){
      _items.update(productId, 
      (existingCardItem) => 
        CartItem(id: productId, title: title, price: price, quantity: existingCardItem.quantity + 1));
    }else {
      _items.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(), title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }


}