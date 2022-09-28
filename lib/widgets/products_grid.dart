//costruisce la lista di prodotto e ASCOLTA Products (il Prpovider)
import 'package:flutter/material.dart';
import 'package:shopapp/widgets/product_item.dart';

import '../models/product.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    required this.loadedProducts,
  }) : super(key: key);

  final List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
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
