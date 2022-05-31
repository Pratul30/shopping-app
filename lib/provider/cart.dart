import 'package:flutter/material.dart';
class Cart{
  String id;
  String title;
  double price;
  int quantity;

  Cart(this.id,this.title,this.price,this.quantity);

}

class CartProduct with ChangeNotifier{
  Map<String,Cart> _cartproduct = {} ;
  Map<String,Cart> get cartproduct{
    return {..._cartproduct};
  } 

  int get cartcount{
    return _cartproduct.length;
  }

  double get cartprice{
    double total = 0.0;
    _cartproduct.forEach((key,cartitem){
      total = total + cartitem.price * cartitem.quantity;
    }); 
    return total;
  }

  void addcart(String id, String title, double price){
    if(_cartproduct.containsKey(id)){
      _cartproduct.update(id,(previouscart)=>Cart(
        previouscart.id,previouscart.title,previouscart.price,previouscart.quantity+1)
      );
    }
    else{
      _cartproduct.putIfAbsent(id,()=>Cart(DateTime.now().toString(),title,price,1));
    }
    notifyListeners();
  }

  void removeCart(String productId){
    _cartproduct.remove(productId);
    notifyListeners();
  }

  void removecartproduct(String productid){
    if(!_cartproduct.containsKey(productid)){
      return;
    }
    if(_cartproduct[productid].quantity>1){
      _cartproduct.update(productid,(existingcart){
        return Cart(existingcart.id,existingcart.title,existingcart.price,existingcart.quantity-1);
      });
    }
    else{
      _cartproduct.remove(productid);
    }
    notifyListeners();
  }



  void cartclear(){
    _cartproduct={};
    notifyListeners();
  }
}