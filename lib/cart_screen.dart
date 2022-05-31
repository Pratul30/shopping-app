import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './cart_item.dart';
class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final cartproduct = Provider.of<CartProduct>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10
                  ),
                Text('Total Amount', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )),
                Spacer(),
                Chip(
                  label: Text('Rs. ${cartproduct.cartprice.roundToDouble()}',
                  style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green,
                ),
                SizedBox(width: 10),
                OrderButton(cartproduct: cartproduct)
              ]
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              itemBuilder: (ctx,i) => CartItem(
                cartproduct.cartproduct.values.toList()[i].id,
                cartproduct.cartproduct.keys.toList()[i],
                cartproduct.cartproduct.values.toList()[i].title,
                cartproduct.cartproduct.values.toList()[i].price,
                cartproduct.cartproduct.values.toList()[i].quantity,
              ),
              itemCount: cartproduct.cartcount,
            )
          )
        ]
      )
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartproduct,
  }) : super(key: key);

  final CartProduct cartproduct;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: isLoading ? CircularProgressIndicator() : Text('Order'),
      onPressed: (widget.cartproduct.cartprice>0 && !isLoading) ? () async {
        setState(() {
          isLoading = true;
        });
        await Provider.of<OrderProduct>(context,listen: false).addorder(widget.cartproduct.cartprice,widget.cartproduct.cartproduct.values.toList());
        setState(() {
          isLoading = false;
        });
        widget.cartproduct.cartclear();
      }:null
    );
  }
}