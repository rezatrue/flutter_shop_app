
import 'package:flutter/foundation.dart';

class CartItem{
  String id;
  String title;
  double price;
  int quantity;

  CartItem({
    @required this.id,
    @required this.title, 
    @required this.price, 
    @required this.quantity
    });
}

class Cart with ChangeNotifier{
  // sence we don't need to add different CartItem for same type of 
  // product (increasing product quantity will do the job) , we use productId as Map key
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

  void removeSingleItem(String productId){
    print('id ' + productId);
    if(!_items.containsKey(productId)) {
      print('return ' + productId);
      return;
    }
    if(_items[productId].quantity > 1){
      _items.update(productId, (exextingItem) => CartItem(
        id: exextingItem.id, title: exextingItem.title, price: exextingItem.price, quantity: exextingItem.quantity -1 ));
    print('id -i' + productId);
    }
    else {
       _items.remove(productId); // remove by CartItem key
      //_items.removeWhere((_, item) => item.id == productId ); // remove using product ID
      print('id removed ' + productId);
    }
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