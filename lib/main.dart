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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: ((ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items)),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProduct(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProduct>(
          create: (ctx) => OrderProduct(null, null, []),
          update: ((ctx, auth, previousProducts) => OrderProduct(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.orderproduct)),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false, //debug tag hide
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.red,
              accentColor: Colors.blue,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              '/product_detail': (context) => ProductsDetail(),
              '/cart_screen': (context) => CartScreen(),
              '/order_screen': (context) => OrderScreen(),
              '/user_screen': (context) => UserScreen(),
              '/edit_screen': (context) => EditScreen(),
            },
          );
        },
      ),
    );
  }
}
