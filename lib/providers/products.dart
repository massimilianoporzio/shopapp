import 'package:flutter/material.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  //my STATE for products stuff
  List<Product> _items =
      []; //not final the entire _items can be assigned dynamically

  List<Product> get items {
    return [
      ..._items
    ]; // è una copia di cosa contiene _items se no dò aaccesso a _items!
  }

  void addProduct() {
    // ....
    notifyListeners(); //chi ascolta questo provider sa che deve fare rebuild
  }
}
