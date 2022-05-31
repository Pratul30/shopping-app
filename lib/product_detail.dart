import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';

class ProductsDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context,listen:false).findbyid(productid);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 200,
            fit: BoxFit.cover,
            width: double.infinity,
            ),
        SizedBox(
          height: 10,
        ),
        Text(
          product.title,
          ),
        SizedBox(height: 10),
        Text(product.price.toString())
        ]
      )
    );
  }
}