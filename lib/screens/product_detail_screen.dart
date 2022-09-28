import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    //se PRODUCTS cambia NON rifaccio build
    final loadedProduct = //con listen a false io costruisco una volta e poi non ascolto più cambiamenti
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
