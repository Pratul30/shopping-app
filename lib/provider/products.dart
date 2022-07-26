import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dummy_data.dart';
import './product.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  Product findbyid(String id) {
    return _items.firstWhere((product) {
      return product.id == id;
    });
  }

  List<Product> get productsfavorite {
    return _items.where((product) {
      return product.isFavorite;
    }).toList();
  }

  Future<void> fetch([bool filter = false]) async {
    final String str =
        filter == true ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken$str');
    try {
      final response = await http.get(url);
      final responsemap = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> productlist = [];
      if (_items.isEmpty && responsemap.isEmpty) {
        return;
      }
      url = Uri.parse(
          'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final newResponse = await http.get(url);
      final newFavoriteMap = json.decode(newResponse.body);
      responsemap.forEach((id, value) {
        productlist.add(
          Product(
            id: id,
            title: value['title'],
            desc: value['desc'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite:
                newFavoriteMap == null ? false : newFavoriteMap[id] ?? false,
          ),
        );
      });
      _items = productlist;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'desc': product.desc,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      final newproduct = Product(
          title: product.title,
          price: product.price,
          desc: product.desc,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'].toString());
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products/${product.id}.json?auth=$authToken');
    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'desc': product.desc,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }));
    final productindex =
        _items.indexWhere((tempproduct) => tempproduct.id == product.id);
    _items[productindex] = product;
    notifyListeners();
  }

  void delete(String id) {
    final url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final productindex = _items.indexWhere((product) => product.id == id);
    var productdata = _items[productindex];
    _items.removeAt(productindex);
    http.delete(url).then((_) {
      productdata = null;
    }).catchError((_) {
      _items.insert(productindex, productdata);
    });
    notifyListeners();
  }
}
