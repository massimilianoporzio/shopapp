import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart' as cartItemWidget;
import '../providers/cart.dart' as cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: Consumer<cart.Cart>(
        builder: (context, cart, child) => Column(children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        formatCurrency.format(cart.totalAmount),
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    TextButton(onPressed: () {}, child: const Text('ORDER NOW'))
                  ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //*RICORDA CHE LISTVIEW IN COLUMN ESPLODE
          Expanded(
              child: ListView.builder(
            itemCount: cart.cartItemCount,
            itemBuilder: (context, index) {
              final item = cart.items.values.elementAt(index);
              final productId = cart.items.keys.elementAt(index);
              return cartItemWidget.CartItem(
                  productId: productId,
                  title: item.title,
                  quantity: item.quantity,
                  price: item.price);
            },
          ))
        ]),
      ),
    );
  }
}
