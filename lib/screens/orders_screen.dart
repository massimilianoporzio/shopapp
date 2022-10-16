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
  late Future _oredersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //* OTTENGO LA FUTURE UNA SOLA VOLTA!
  }

  @override
  void initState() {
    _oredersFuture = _obtainOrdersFuture();
    super.initState();
  }

  // var _isLoading = false;
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

  // @override
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context); //! NO SE NO LOOP INFINITO
    //! andrebbe a chiedere di fare build!
    return Scaffold(
        appBar: AppBar(title: const Text('Your orders')),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _oredersFuture, //* è già il risultato del fetch!
            //* così se rifaccio build per qualche altro pezzo dell'albero
            //*widgets NON verrà richiamata un'altra Future
            //* altrimenti faccio altra richiesta http ad ogni rebuild!
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //* is loading!
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary),
                );
              } else {
                //*is done! check for errors
                if (snapshot.error != null) {
                  showErrorDialog(context);
                  return Center(
                      child: Text(
                    'Something went wrong!',
                    style: Theme.of(context).textTheme.headline6,
                  ));
                } else {
                  //* non ci sono errori
                  return Consumer<Orders>(
                    builder: (context, orderData, child) {
                      return orderData.orders.isNotEmpty
                          ? ListView.builder(
                              itemCount: orderData.orders.length,
                              itemBuilder: (context, index) =>
                                  OrderItem(order: orderData.orders[index]),
                            )
                          : Center(
                              child: Text(
                              'You have no orders yet',
                              style: Theme.of(context).textTheme.headline6,
                            ));
                    },
                  );
                }
              }
            }));
  }
}
