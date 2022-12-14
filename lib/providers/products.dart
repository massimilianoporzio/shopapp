import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  final String? authToken;
  static const host =
      "shopapp-firebase-local-default-rtdb.europe-west1.firebasedatabase.app";

  final String? userId;

  //my STATE for products stuff
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description:
    //       'A red shirt - it is pretty red!\nEa reprehenderit cupidatat aute pariatur tempor eu est veniam nisi in amet adipisicing qui. Nulla aute laborum eiusmod officia ea anim Lorem labore sint. Aliqua magna consequat magna laborum eu mollit nostrud et. Excepteur laborum nulla velit cillum do. Proident velit non nulla excepteur consectetur quis fugiat exercitation dolore amet velit cupidatat consequat id. Culpa ad occaecat consectetur quis aliquip qui sit.',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Products(this.authToken, this._items,
      this.userId); //not final the entire _items can be assigned dynamically

  List<Product> get items {
    //*lo uso se voglio a livello globale ma di solito
    // if (_showFavoritesOnly) {
    //   return _items
    //       .where((element) => element.isFavorite)
    //       .toList(); //* ?? una nuova lista in automatico
    // } else {
    return [..._items];
    // } // ?? una copia di cosa contiene _items se no d?? aaccesso a _items!
  }

  List<Product> get favoritesItems {
    return items.where((element) => element.isFavorite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> editProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final queryParams = {
        'ns': 'shopapp-firebase-local-default-rtdb',
        'auth': authToken,
        'access_token': authToken,
      };

      final url = Uri.https(host, "products/$id.json", queryParams);
      try {
        final response = await http.put(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "price": newProduct.price,
              "imageUrl": newProduct.imageUrl
            })); //update delle sole info acquisite dal form
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        print(e);
        rethrow; //lo catturo dal widget
      }

      // return _items[prodIndex].copyWith();
    } else {
      print('---');
    }
  }

  Future<void> deleteProduct(String id) async {
    final queryParams = {
      'ns': 'shopapp-firebase-local-default-rtdb',
      'auth': authToken,
      'access_token': authToken,
    };
    // final host = Platform.isAndroid ? "10.0.2.2:9000" : "127.0.0.1:9000";
    final url = Uri.https(host, "products/$id.json", queryParams);
    //*mi tengo l'indice dell'elemento che voglio cancellare
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    //*mi prendo un puntatore (reference) all'elemento della mia lista locale
    //*dart rimuove l'elemento dalla lista ma NON cancella l'elemento
    //*perch?? ho ancora qualcosa che punta a lui
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex); //TOLGO DALLA LISTA LOCALE
    notifyListeners(); //aggiorno UI
    //*ora la lista local non ce l'ha pi??

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      //!qualcosa di storto
      //*LO RIMETTO IN LISTA LOCALE! perch?? NON SONO RIUSCIUTO A TOGLIERLO DAL DB
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners(); //e riaggiorno
      throw const HttpException('Could not delete product.');
    }

    //*ho avuto successo con l'API
    //*metto a null il puntatore cos?? libero memoria
    existingProduct = null;
  }

  Future<Product> addProduct(Product product) async {
    // ....
    //*send http request to backend
    //*(take same time to finish) but app goes on
    var newProduct = Product(
        description: "",
        id: "-2",
        imageUrl: "",
        price: 0,
        title: "",
        isFavorite: false);
    final queryParams = {
      'ns': 'shopapp-firebase-local-default-rtdb',
      'auth': authToken,
      'access_token': authToken,
    };
    // final host = Platform.isAndroid ? "10.0.2.2:9000" : "127.0.0.1:9000";
    final url = Uri.https(host, "products.json", queryParams);

    //* products.json is firebase related and create if does not exisit a new collection

    //* POST request: (async-return a Future)
    //*tolgo return se uso async

    try {
      //*codice che non hai garanzia funzioni senza errori (chiamo un server)
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId // SALVO SOLO SUL SERVER!!!! NON localmente
            // 'isFavorite': product.isFavorite NON LO PASSO PIU QUANDO CREO PRODOTTO
          }));
      //* eseguita DOPO che il server ha risposto
      //*con async hai le linee seguenti dentro una Future then
      newProduct = Product(
          id: json.decode(response.body)[
              'name'], //*from firebase return the id as 'name' on body response
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners(); //chi ascolta questo provider sa che deve fare rebuild
    } catch (error) {
      print(error);
      rethrow; //rilancio l'errore cosi nella pagina reagisco
    }
    return newProduct;
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

  //*leggo da API e setto la lista dei prodotti
  //*[] sono arg opzionali con default
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    //FILTRO SOLO I PRODOTTI DELLO USER LOGGATO! (LATO SERVER)

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    await Future.delayed(const Duration(seconds: 1));
    var queryParams = {
      // 'ns': 'shopapp-firebase-local-default-rtdb',
      'access_token': authToken,
      'auth': authToken,
    };
    if (filterByUser) {
      queryParams['orderBy'] = '"creatorId"';
      queryParams['equalTo'] = json.encode(userId);
    }
    // final host = Platform.isAndroid ? "10.0.2.2:9000" : "127.0.0.1:9000";

    var url = Uri.https(host, "products.json", queryParams);
    try {
      final List<Product> loadedProducts = [];
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //*map with other map as values and id as keys
      if (extractedData.isEmpty) {
        return;
      }
      //PRENDO SE PER QUELL'UTENTE IL PRODOTTO ?? FAVORITE
      queryParams = {
        // 'ns': 'shopapp-firebase-local-default-rtdb',
        'auth': json.encode(authToken),
        'access_token': json.encode(authToken),
      };
      url = Uri.https(host, "userFavorites/$userId.json", queryParams);
      final favoriteResponse = await http.get(url, headers: headers);
      //* mi restituisce Map productId -> true or false
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData == null
                ? false
                : favoriteData[prodId] ??
                    false)); //se non c'?? entry per prodId allora metto a false
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow; //*lo rilancio per catturarlo nel widget!
    }
  }
}
