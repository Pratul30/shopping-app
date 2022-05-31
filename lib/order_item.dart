import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './provider/order.dart' as ord;
class Order extends StatefulWidget {

  final ord.Order order;

  Order(this.order);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Rs. ${widget.order.price}',style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Date: ${DateFormat('dd-MM-yyyy').format(widget.order.datetime)} \t Time:${DateFormat('hh:mm').format(widget.order.datetime)}',
            style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less :Icons.expand_more),
              onPressed:(){
                setState((){
                  expanded = !expanded;
                });
              }
            )
          ),
          if(expanded) Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 200,
            child: ListView(
              children: widget.order.cartitems.map((order){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.title),
                    Text('Rs. ${order.price} * ${order.quantity}')
                  ]
                );
              }).toList()
            )
          )
        ]
      )
    );
  }
}