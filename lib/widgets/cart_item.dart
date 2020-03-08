import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  //final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
          key: ValueKey(id),
          background: Container(
            color: Theme.of(context).errorColor,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.delete, size: 40, color: Colors.white,)),
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
              ),
            ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
              Provider.of<Cart>(context, listen: false).removeItem(id);
          },
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove the Item from the Cart?'),
                actions: <Widget>[
                  FlatButton( 
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },),
                  FlatButton( 
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },),
                ],
              ),
              );
          },
          child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8), 
          child: ListTile(
            leading: CircleAvatar(child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(child: Text('\$$price'))),),
            title: Text(title),
            subtitle: Text('Total:\$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
          ),
        
      ),
    );
  }
}