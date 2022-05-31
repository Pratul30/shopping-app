import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/product.dart';
import './provider/cart.dart';
import './provider/products.dart';

class ProductItem extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final productitem = Provider.of<Product>(context);
    final cartitem = Provider.of<CartProduct>(context);
    return GestureDetector(
      onTap: (){
        ChangeNotifierProvider(
          create: (ctx) => Products()
        );
        Navigator.pushNamed(context,'/product_detail',arguments: productitem.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              icon: productitem.isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              onPressed: (){
                productitem.togglefavorite();
              },
              ),
            title: Text(productitem.title),
            trailing: IconButton(icon:Icon(Icons.shopping_cart),
            onPressed: (){
              cartitem.addcart(productitem.id,productitem.title,productitem.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product added to Cart!'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: (){
                      cartitem.removecartproduct(productitem.id);
                    }
                  )
                )
              );
              }
            )
          ), 
          child: Image.network(productitem.imageUrl,fit: BoxFit.cover,),

        ),
      ),
    );
  }
}