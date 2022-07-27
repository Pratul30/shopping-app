import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/auth.dart';

class HamburgerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      AppBar(
        title: Text('Hello'),
        automaticallyImplyLeading: false,
      ),
      Divider(),
      ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.attach_money),
          title: Text('Order'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/order_screen');
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/user_screen');
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<Auth>(context, listen: false).logout();
          }),
    ]));
  }
}
