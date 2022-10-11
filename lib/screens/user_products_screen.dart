import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    //non setto listner just refresh products
    try {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    } catch (e) {
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
  }

  @override
  Widget build(BuildContext context) {
    //*SETUP LISTENER FOR PRODUCTS
    final productData = Provider.of<Products>(
        context); //*listening: tutta la pagina rebuild se cambiano i Products
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your custom product'),
        actions: [
          IconButton(
              onPressed: () {
                //*navigate to new page for adding custom products
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () {
          //*has to return a Future
          return _refreshProducts(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (context, index) {
              final product = productData.items[index];
              return Column(
                children: [
                  UserProductItem(
                      id: product.id,
                      title: product.title,
                      imageUrl: product.imageUrl),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
