import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/product_item.dart';

import '../providers/product.dart';
import '../providers/products.dart';

//costruisce la lista di prodotto e ASCOLTA Products (il Prpovider)
class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({Key? key, required this.showFavs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //stabilisce connessione dietro le quinte con il provider instance
    final productData = Provider.of<Products>(context);
    final loadedProducts =
        showFavs ? productData.favoritesItems : productData.items;
    if (loadedProducts.isEmpty) {
      final message = showFavs
          ? 'You have no favorites yet! Try adding one!'
          : 'No products available';
      return Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    } else {
      return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (ctx, i) {
            Product product = loadedProducts[i];
            // qui attacco il provider dello specifico product

            return ChangeNotifierProvider.value(
              value: product,
              child: ProductItem(),
            );
          });
    }
  }
}
