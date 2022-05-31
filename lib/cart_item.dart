import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String productid;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id,this.productid,this.title,this.price,this.quantity);
 
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (_){
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Confirm Delete?'),
            content: Text('Confirm deleting the item from cart.'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: (){
                  Navigator.of(ctx).pop(false);
                }
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: (){
                  Navigator.of(ctx).pop(true);
                }
              )
            ]
          )
        );
      },
      key: ValueKey(id),
      background: Container(
      padding: EdgeInsets.only(right: 20), 
      alignment: Alignment.centerRight,
      color: Colors.red,
      margin: EdgeInsets.all(10),
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
        )
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('$price')
                      ),
                  ),
            ),
            title: Text(title),
            subtitle: Text('Total Rs. ${price*quantity}'),
            trailing: Text('Quantity: $quantity', 
            style: TextStyle(fontWeight: FontWeight.bold)
            )
          )
        )
      ),
    onDismissed: (_){
      Provider.of<CartProduct>(context,listen: false).removeCart(productid);
    }
    );
  }
}