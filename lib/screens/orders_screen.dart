import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/order_item.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart'; //*import only Orders

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your orders')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) =>
            OrderItem(order: orderData.orders[index]),
      ),
    );
  }
}
