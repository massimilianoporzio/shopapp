import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part "cart.g.dart";

@JsonSerializable()
class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.productId,
      required this.title,
      required this.quantity,
      required this.price});

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  // Map toJson() => {
  //       'id': id,
  //       'title': title,
  //       'quantity': quantity,
  //       'price': price,
  //     };
}

class Cart with ChangeNotifier {
  final uuid = const Uuid();
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

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseQuantityOfItem(String productId, int actualQuantity) {
    if (actualQuantity <= 1) {
      _items.removeWhere((key, value) => key == productId);
    } else {
      _items.update(
          productId,
          (oldCartItem) => CartItem(
              id: oldCartItem.id,
              productId: productId,
              title: oldCartItem.title,
              quantity: oldCartItem.quantity - 1,
              price: oldCartItem.price));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      //*NON CONTIENE ANCORA
      return;
    } else {
      if (_items[productId]!.quantity > 1) {
        _items.update(
            productId,
            (exsitingCartItem) => CartItem(
                id: exsitingCartItem.id,
                productId: exsitingCartItem.productId,
                title: exsitingCartItem.title,
                quantity: exsitingCartItem.quantity - 1,
                price: exsitingCartItem.price));
      } else {
        //*SOLO 1: rimuovo tutto
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //*ho gi?? il prodotto in cart
      //change quantity
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              productId: existingCartItem.productId,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1, // AUMENTO
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          (() => CartItem(
              id: uuid.v4(),
              productId: productId,
              title: title,
              price: price,
              quantity: 1)));
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
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
