import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/order_item.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart'; //*import only Orders

//*stateful perché ho bis di init o di didChangeDependencies
class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

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
  // void initState() {
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });
  //   // //* uso THEN perché NON voglio ritornare un Future
  //   // Future.delayed(Duration.zero).then(
  //   //   (_) async {
  //   //     try {
  //   //       await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   //       setState(() {
  //   //         _isLoading = false;
  //   //       });
  //   //     } catch (e) {
  //   //       setState(() {
  //   //         _isLoading = false;
  //   //       });
  //   //       print(e);
  //   //       showErrorDialog(context);
  //   //     }
  //   //   },
  //   // ); //dura 0 ma ritorna Future

  //   //* commentato per usare il FutureBuilder
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context); //! NO SE NO LOOP INFINITO
    //! andrebbe a chiedere di fare build!
    return Scaffold(
        appBar: AppBar(title: const Text('Your orders')),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
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
