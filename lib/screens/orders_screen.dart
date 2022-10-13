import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/order_item.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart'; //*import only Orders

//*stateful perché ho bis di init o di didChangeDependencies
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
  void initState() {
    setState(() {
      _isLoading = true;
    });
    //* uso THEN perché NON voglio ritornare un Future
    Future.delayed(Duration.zero).then(
      (_) async {
        try {
          await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          print(e);
          showErrorDialog(context);
        }
      },
    ); //dura 0 ma ritorna Future
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your orders')),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary),
            )
          : orderData.orders.isNotEmpty
              ? ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) =>
                      OrderItem(order: orderData.orders[index]),
                )
              : Center(
                  child: Text(
                  'You have no orders yet',
                  style: Theme.of(context).textTheme.headline6,
                )),
    );
  }
}
