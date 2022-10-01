import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;
  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(formatCurrency.format(order.amount)),
          subtitle:
              Text(DateFormat('dd/MM/yyyy hh:mm').format(order.orderDate)),
          trailing: IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: () {},
          ),
        )
      ]),
    );
  }
}
