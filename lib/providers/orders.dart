import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem {
  String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem(
      {this.id = "-1", //default
      required this.amount,
      required this.products,
      required this.orderDate});

  Map toJson() => {
        'id': id,
        'amount': amount,
        'products': products,
        'dateTime': orderDate.toIso8601String(),
      };
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders]; //* + una COPIA
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final queryParams = {'ns': 'shopapp-firebase-local-default-rtdb'};
    final host = Platform.isAndroid ? "10.0.2.2:9000" : "127.0.0.1:9000";
    final url = Uri.http(host, "orders.json", queryParams);

    final timeStamp = DateTime.now();
    final newOrder = OrderItem(
        amount: totalAmount, products: cartProducts, orderDate: timeStamp);
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http.post(url, body: json.encode(newOrder));
      //ASSOCIO L'ID GENERATO DA FIREBASE (DALLA API)
      newOrder.id = json.decode(response.body)[
          'name']; //*from firebase return the id as 'name' on body response
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow; //DA GESTIRE NEL WIDGET
    }

    // _orders.insert(
    //     0,
    //     OrderItem(
    //         id: uuid.v4(), //* inserisci ALL'INIZIO
    //         amount: totalAmount,
    //         products: cartProducts,
    //         orderDate: DateTime.now()));
    notifyListeners();
  }
}
