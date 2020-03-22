import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/Orsers';

  // var _isLoading = false;
  // @override
  // void initState() {
  //     _isLoading = true;
  //     Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_){
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Order'),),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
          }else {
            if(dataSnapshot.error != null){
                // ..
              return Center(child: Text('Error occoured')); 
            }else {
              return Consumer<Orders>(builder: (ctx,orderData, child ) {
                return ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(orderItem: orderData.orders[i]),
                );
              },) ;
            }
          }
        },
      ),
      
    );
  }
}