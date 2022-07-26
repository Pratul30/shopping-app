import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';
import './user_item.dart';
import './hamburger_menu.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var isLoading = true;

  @override
  void initState() {
    Provider.of<Products>(context, listen: false).fetch(true).then((response) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Products'), actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit_screen');
            })
      ]),
      drawer: HamburgerMenu(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Provider.of<Products>(context, listen: false)
                    .fetch(true);
              },
              child: ListView.builder(
                itemBuilder: (ctx, i) => Column(
                  children: [
                    UserItem(products.delete, products.items[i].id,
                        products.items[i].title, products.items[i].imageUrl),
                    Divider(
                      thickness: 5,
                    )
                  ],
                ),
                itemCount: products.items.length,
              ),
            ),
    );
  }
}
