 import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
 import './provider/products.dart';
 import './user_item.dart';
 import './hamburger_menu.dart';
class UserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed('/edit_screen');
            }
          )
        ]
      ),
      drawer: HamburgerMenu(),
      body: RefreshIndicator(
        onRefresh: (){
          return Provider.of<Products>(context, listen:false).fetch();
        },
        child: ListView.builder(
          itemBuilder: (ctx,i) => Column(
            children: [
              UserItem(products.delete,products.items[i].id,products.items[i].title,products.items[i].imageUrl),
              Divider(
                thickness: 5,
              )
            ]
          ),
          itemCount: products.items.length, 
        ),
      )
    );
  }
}