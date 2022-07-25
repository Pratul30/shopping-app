import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './cart_screen.dart';
import './product_detail.dart';
import './order_screen.dart';
import './user_screen.dart';
import './edit_screen.dart';
import './auth_screen.dart';
import './provider/auth.dart';
import 'products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProduct(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrderProduct(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false, //debug tag hide
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.blue,
            fontFamily: 'Lato',
          ),
          home: AuthScreen(),
          routes: {
            '/product_detail': (context) => ProductsDetail(),
            '/cart_screen': (context) => CartScreen(),
            '/order_screen': (context) => OrderScreen(),
            '/user_screen': (context) => UserScreen(),
            '/edit_screen': (context) => EditScreen(),
          }),
    );
  }
}
