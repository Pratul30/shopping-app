import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final String desc;
  @required
  final double price;
  @required
  final String imageUrl;
  bool isFavorite;

  Future<void> togglefavorite(String authToken, String userId) async {
    bool favorite = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse(
        'https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    try {
      final reponse = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (reponse.statusCode >= 400) {
        isFavorite = favorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
    }

    notifyListeners();
  }

  Product(
      {this.id,
      this.title,
      this.desc,
      this.price,
      this.imageUrl,
      this.isFavorite = false});
}
