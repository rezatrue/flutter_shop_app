import 'package:flutter/material.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';


enum FilterOptions {
 Favotire,
 All,
}

class ProductsOverviewScreen extends StatefulWidget {

  
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    //final productContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'),
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if(selectedValue == FilterOptions.Favotire){
                //productContainer.showFavoritesOnly();
                _showOnlyFavorites = true;
            }else{
                //productContainer.showAll();
                _showOnlyFavorites = false;
            }
            });
            
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorite'), value: FilterOptions.Favotire,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
          ],
          ),
         Consumer<Cart>(
           builder: (_, cart, ch) => 
            Badge(
              child: ch, 
              value: cart.itemCount.toString()
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart), 
                onPressed: (){
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                })
           ), 
        
      ],
      ),
      body: ProductGrid(_showOnlyFavorites),
      
    );
  }
}

