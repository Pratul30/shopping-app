import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final String id;
  final double price;
  final List<Cart> cartitems;
  final DateTime datetime;

  Order({this.id, this.price, this.cartitems, this.datetime});
}

class OrderProduct with ChangeNotifier {
  final String authToken;
  final String userId;
  OrderProduct(this.authToken, this.userId, this._orderproduct);

  List<Order> _orderproduct = [];

  List<Order> get orderproduct {
    return [..._orderproduct];
  }

  Future<void> fetch() async {
    final List<Order> orders = [];
    final url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final responsemap = json.decode(response.body) as Map<String, dynamic>;
      if (responsemap == null) {
        return;
      }
      responsemap.forEach((key, value) {
        orders.add(Order(
            id: key,
            price: value['price'],
            datetime: DateTime.parse(value['datetime']),
            cartitems: (value['cartitems'] as List<dynamic>).map((cartmap) {
              return Cart(cartmap['id'], cartmap['title'], cartmap['price'],
                  cartmap['quantity']);
            }).toList()));
      });
      _orderproduct = orders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addorder(double total, List<Cart> cartorder) async {
    final url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      final datetime = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'price': total,
            'cartitems': cartorder.map((cartproduct) {
              return {
                'id': cartproduct.id,
                'title': cartproduct.title,
                'price': cartproduct.price,
                'quantity': cartproduct.quantity
              };
            }).toList(),
            'datetime': datetime.toIso8601String(),
          }));
      final newOrder = Order(
          price: total,
          cartitems: cartorder,
          datetime: datetime,
          id: json.decode(response.body)['name'].toString());
      _orderproduct.add(newOrder);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  int ordercount() {
    return _orderproduct.length;
  }
}
