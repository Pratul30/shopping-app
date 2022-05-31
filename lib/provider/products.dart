import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dummy_data.dart';
import './product.dart';
class Products with ChangeNotifier{
  List<Product> _items= [];
  List<Product> get items{
    return [..._items];
  }

  Product findbyid(String id){
    return _items.firstWhere((product){return product.id==id;});
  }

  List<Product> get productsfavorite{
    return _items.where((product){return product.isFavorite;}).toList();
  }

  Future<void> fetch() async {
    final url = Uri.parse('https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try{
    final response = await http.get(url);
      final responsemap = json.decode(response.body) as Map<String,dynamic>;
      final List<Product> productlist = [];
      if(_items.isEmpty && responsemap.isEmpty){
        return ;
      }
      else{
      responsemap.forEach((id,value){
        productlist.add(
          Product(
            id: id,
            title: value['title'],
            desc: value['desc'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite']
          )
        );
      });
      }
      _items = productlist;
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
    final response = await http.post(url,body:json.encode({
      'title': product.title,
      'desc': product.desc,
      'price' : product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite
    }));
      final newproduct = Product(
      title: product.title,
      price: product.price,
      desc: product.desc,
      imageUrl: product.imageUrl,
      id: json.decode(response.body)['name'].toString()
    );
    _items.add(newproduct);
    notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async{
   final url = Uri.parse('https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products/${product.id}.json');
   await http.patch(url,body: json.encode({
     'title': product.title,
     'desc': product.desc,
     'imageUrl': product.imageUrl,
     'price': product.price,
   }
   )
   );
      final productindex = _items.indexWhere((tempproduct) => tempproduct.id == product.id);
     _items[productindex] = product;
     notifyListeners();
  }

  void delete(String id) {
    final url = Uri.parse('https://shop-10865-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    final productindex = _items.indexWhere((product) => product.id==id);
    var productdata = _items[productindex];
    _items.removeAt(productindex);
    http.delete(url).then((_){
      productdata = null;
    }).catchError((_){
      _items.insert(productindex,productdata);
    });
    notifyListeners();
  }
}