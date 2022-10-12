// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' as cart;
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart' as cartItemWidget;

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
                    OrderButton(
                      cart: cart,
                    )
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

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  Future<void> showErrorDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("An error occured!"),
        content: const Text("Something went wrong."),
        actions: [
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop(); //chiudo
              }),
              child: Text(
                'OK',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 ||
                _isLoading) //non ho prodotti nel carrello o sto caricando
            //PUNTO A NULL COSI HO BOTTONE DISABILITATO!
            ? null
            : () async {
                setState(() {
                  _isLoading =
                      true; //REBUILD SOLO IL TEXTBUTTON (unico stateful)
                });
                try {
                  await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cart.items.values.toList(),
                      widget.cart.totalAmount);
                  widget.cart.clearCart(); //update!!! (rebuild)

                } catch (error) {
                  showErrorDialog(context);
                } finally {
                  setState(() {
                    _isLoading =
                        false; //REBUILD SOLO IL TEXTBUTTON (unico stateful)
                  });
                }
              },
        child: _isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              )
            : const Text('ORDER NOW'));
  }
}
