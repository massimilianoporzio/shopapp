import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:shopapp/providers/product.dart';

import 'cart.dart';

part "orders.g.dart";

@JsonSerializable(explicitToJson: true)
class OrderItem {
  @JsonKey(includeIfNull: false)
  String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem(
      {this.id, //default
      required this.amount,
      required this.products,
      required this.orderDate});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  // Map toJson() => {
  //       'id': id,
  //       'amount': amount,
  //       'products': products,
  //       'dateTime': orderDate.toIso8601String(),
  //     };
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders]; //* + una COPIA
  }

  Future<void> fetchAndSetOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    final queryParams = {'ns': 'shopapp-firebase-local-default-rtdb'};
    final host = Platform.isAndroid ? "10.0.2.2:9000" : "127.0.0.1:9000";
    final url = Uri.http(host, "orders.json", queryParams);
    try {
      final List<OrderItem> loadedOrders = [];
      final response = await http.get(url);
      // final extractedData = json.decode(response.body);
      if (response.body != "null") {
        Map<String, dynamic> ordersMap = jsonDecode(response.body);
        ordersMap.forEach((orderId, orderData) {
          orderData['id'] =
              orderId; //gli assegno come id la chiave con cui arriva da firebase
          final orderItem = OrderItem.fromJson(orderData);
          loadedOrders.add(orderItem);
        });
        _orders = loadedOrders.reversed
            .toList(); //IL PIU RECENTEMENTE INSERITO IN CIMA
        notifyListeners();
      } else {
        _orders = [];
        notifyListeners();
        return; //non fa null'altro
      }
    } catch (e) {
      rethrow; //GET VA IN ECCEZIONE
    }
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
      final response = await http.post(url, body: jsonEncode(newOrder));
      //ASSOCIO L'ID GENERATO DA FIREBASE (DALLA API)
      newOrder.id = json.decode(response.body)[
          'name']; //*from firebase return the id as 'name' on body response
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (e) {
      _orders.removeAt(0); //TORNO INDIETRO
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
