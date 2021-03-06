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
      //appBar: AppBar(title: Text(loadedProduct.title)),
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Text(loadedProduct.title),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(15)), ),
                background: Hero(
                        tag: loadedProduct.id,
                        child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover)
                        ),
                ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                  SizedBox(height: 10,),
                  Text('\$${loadedProduct.price}', style: TextStyle(color: Colors.grey, fontSize: 20,), textAlign: TextAlign.center,),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${loadedProduct.description}', textAlign: TextAlign.center, softWrap: true,)
                    ),
                  SizedBox(height: 800,),
              ])
              ),
          ],
      ),
    );
  }
}