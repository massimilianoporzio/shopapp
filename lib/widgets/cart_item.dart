import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(
      {super.key,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(title),
          subtitle: Text('Total: ${formatCurrency.format(price * quantity)}'),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(formatCurrency.format(price)),
              ),
            ),
          ),
          trailing: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .decreaseQuantityOfItem(productId, quantity);
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.black,
                    )),
                Text('$quantity x'),
                IconButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .addItem(productId, price, title);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
