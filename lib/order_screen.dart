import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/order.dart';
import './order_item.dart' as ord;
import './hamburger_menu.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future futurecall;
  Future returnfuturecall() {
    return Provider.of<OrderProduct>(context, listen:false).fetch();
  }

  @override
  void initState() {
    futurecall = returnfuturecall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderproduct = Provider.of<OrderProduct>(context);
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      drawer: HamburgerMenu(),
      body: FutureBuilder(
          future: futurecall,
          builder: (context, futuresnapshot) {
            if (futuresnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Consumer<OrderProduct>(
              builder: (context, orderproduct, child) {
                return ListView.builder(
                    itemBuilder: (ctx, i) =>
                        ord.Order(orderproduct.orderproduct[i]),
                    itemCount: orderproduct.ordercount());
              },
            );
          },)
    );
  }
}
