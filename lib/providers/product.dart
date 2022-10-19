import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  static const host =
      "shopapp-firebase-local-default-rtdb.europe-west1.firebasedatabase.app";

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite
      };

  Product copyWith() => Product(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite);

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String? token) async {
    //OPTIMISTIC! SALVO lo stato attuale , provo agg il backend
    //*se va male rimetto lo stato attuale
    final oldState = isFavorite;

    final queryParams = {
      'ns': 'shopapp-firebase-local-default-rtdb',
      'auth': token
    };
    // final host = Platform.isAndroid ? "10.0.2.2:9000" : "127.0.0.1:9000";
    final url = Uri.https(host, "products/$id.json", queryParams);

    isFavorite = !isFavorite;
    notifyListeners(); //! chi ascolta chiamerà build
    try {
      final response = await http.patch(url,
          body: json
              .encode({"isFavorite": isFavorite})); //update di solo isFavorite
      if (response.statusCode >= 400) {
        //HTTP PACKAGE NON VA IN ERRORE PER PATCH e DELETE!!!!!REST CODE >=400
        _setFavValue(oldState); //RIPORTO AL VALORE INIZIALE
        throw const HttpException("Failed. Network issue.");
      }
    } catch (e) {
      //HTTP PACKAGE NON VA IN ERRORE PER PATCH e DELETE!!!!!REST CODE >=400
      print(e);
      //ROLL BACK
      _setFavValue(oldState);
      throw const HttpException(
          "Could not change Favorite state!"); //da catturare nel widget
    }
  }
}
