import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final uuid = Uuid();

  //my STATE for products stuff
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description:
          'A red shirt - it is pretty red!\nEa reprehenderit cupidatat aute pariatur tempor eu est veniam nisi in amet adipisicing qui. Nulla aute laborum eiusmod officia ea anim Lorem labore sint. Aliqua magna consequat magna laborum eu mollit nostrud et. Excepteur laborum nulla velit cillum do. Proident velit non nulla excepteur consectetur quis fugiat exercitation dolore amet velit cupidatat consequat id. Culpa ad occaecat consectetur quis aliquip qui sit.',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ]; //not final the entire _items can be assigned dynamically

  List<Product> get items {
    //*lo uso se voglio a livello globale ma di solito
    // if (_showFavoritesOnly) {
    //   return _items
    //       .where((element) => element.isFavorite)
    //       .toList(); //* è una nuova lista in automatico
    // } else {
    return [..._items];
    // } // è una copia di cosa contiene _items se no dò aaccesso a _items!
  }

  List<Product> get favoritesItems {
    return items.where((element) => element.isFavorite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Product? editProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;

      notifyListeners();
      return _items[prodIndex].copyWith();
    } else {
      return null;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product addProduct(Product product) {
    // ....

    final newProduct = Product(
        id: uuid.v4(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    notifyListeners(); //chi ascolta questo provider sa che deve fare rebuild
    return newProduct.copyWith();
  }
  //*lo uso se voglio a livello globale ma di solito
  // var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  void refreshProductsList() {
    notifyListeners(); // rifa fare il rebuild
  }
}
