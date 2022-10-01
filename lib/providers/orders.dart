import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.orderDate});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders]; //* + una COPIA
  }

  void addOrder(List<CartItem> cartProducts, double totalAmount) {
    const uuid = Uuid();
    _orders.insert(
        0,
        OrderItem(
            id: uuid.v4(), //* inserisci ALL'INIZIO
            amount: totalAmount,
            products: cartProducts,
            orderDate: DateTime.now()));
    notifyListeners();
  }
}
