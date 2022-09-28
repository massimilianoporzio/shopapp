import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/product_item.dart';

import '../providers/product.dart';
import '../providers/products.dart';

//costruisce la lista di prodotto e ASCOLTA Products (il Prpovider)
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //stabilisce connessione dietro le quinte con il provider instance
    final productData = Provider.of<Products>(context);
    final loadedProducts = productData.items;
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
          return ProductItem(
              id: product.id,
              title: product.title,
              price: product.price,
              imageUrl: product.imageUrl);
        });
  }
}
