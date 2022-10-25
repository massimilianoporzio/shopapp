import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    //se PRODUCTS cambia NON rifaccio build
    final loadedProduct = //con listen a false io costruisco una volta e poi non ascolto più cambiamenti
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.secondary),
            expandedHeight: 300,
            pinned: true, //always visibile during scrolling
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id, //* the same unique id
                child: Container(
                  color: Colors.white,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 10,
              ),
              Text(
                formatCurrency.format(loadedProduct.price),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 22),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  // textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 24),
                  softWrap: true, //* nuova linea se descrizione lunga
                ),
              ),
              const SizedBox(
                height: 800,
              )
            ]),
          )
        ],
      ),
    );
  }
}
