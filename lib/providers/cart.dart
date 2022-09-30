import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  final uuid = Uuid();
  Map<String, CartItem> _items = {}; //* PRODUCT ID vs CartItem

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    //il numero di PRODOTTI NEL CARRELLO
    int total = 0;
    for (var element in _items.entries) {
      total += element.value.quantity;
    }
    return total;
  }

  int get cartItemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //*ho già il prodotto in cart
      //change quantity
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1, // AUMENTO
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          (() => CartItem(
              id: uuid.v4(), title: title, price: price, quantity: 1)));
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
}
