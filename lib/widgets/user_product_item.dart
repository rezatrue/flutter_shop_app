import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';

class UseProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UseProductItem({this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      trailing: Container(
              width: 100,
              child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit), 
            color: Theme.of(context).primaryColor, 
            onPressed: () {
            },),
            IconButton(icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor ,
            onPressed: () {},),
          ],
        ),
      ),
      
    );
  }
}