import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';
import './provider/badge.dart';
import './provider/cart.dart';
import './product_item.dart';
import './hamburger_menu.dart';

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var favoritepass = false;
  bool isloading = true;

  @override
  void initState(){
    Provider.of<Products>(context,listen: false).fetch().then((response){
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final productsdata = Provider.of<Products>(context);
    final cartdata = Provider.of<CartProduct>(context);
    final products = favoritepass ? productsdata.productsfavorite : productsdata.items;


    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Favorites'),value: 0),
              PopupMenuItem(child: Text('All'),value: 1),
            ],
            onSelected: (int favvalue){
              setState((){
              if(favvalue==0){
                favoritepass= true;
              }
              else{
                favoritepass=false;
              }
            }
           );
          }
          ),
          Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed('/cart_screen');
              }
            ),
            value: cartdata.cartcount.toString()
          )
        ],
      ),
      drawer: HamburgerMenu(),
      body: isloading ? Center(
        child: CircularProgressIndicator()
        ) : 
        GridView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (contextBuilder,index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem()),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 3/2,
        )
      )
    );
  }
}