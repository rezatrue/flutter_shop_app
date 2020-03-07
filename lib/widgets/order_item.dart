import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem({this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

var _expanded = false;

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more), 
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              }),
          ),
          if(_expanded) 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                height: min(widget.orderItem.products.length * 20.0 + 10 , 120),
                child: ListView(
                  children: widget.orderItem.products.map((prod) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(prod.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Text('${prod.quantity}x \$${prod.price}', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  )).toList(),),
                ),
          
        ],
      ),
    );
  }
}