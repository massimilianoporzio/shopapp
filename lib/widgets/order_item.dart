import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as ord;
import '../providers/products.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  //* vedere i dettagli espandendo non deve interessare al resto della app
  //* GESTISCO COME STATEFUL WIDGET IN LOCALE
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(formatCurrency.format(widget.order.amount)),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.orderDate)),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded; //TOGGLE
              });
            },
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: min(widget.order.products.length * 60.0 + 80,
                0.9 * MediaQuery.of(context).size.height),
            child: ListView.builder(
              itemCount: widget.order.products.length,
              itemBuilder: (context, index) {
                final productInOrder = widget.order.products[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          productInOrder.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Consumer<Products>(
                          builder: (context, products, child) {
                            final product =
                                products.findById(productInOrder.productId);
                            return Container(
                              width: 80,
                              height: 40,
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                    Text(
                      '${productInOrder.quantity}x ${NumberFormat.simpleCurrency().format(productInOrder.price)}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                );
              },
            ),
          )
      ]),
    );
  }
}
