import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';

class ProductsDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findbyid(productid);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
              ),
              background: Hero(
                tag: productid,
                child: Image.network(
                  product.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  product.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  product.price.toString(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5000,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
