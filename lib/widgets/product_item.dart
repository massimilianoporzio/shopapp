import 'package:ellipsis_overflow_text/ellipsis_overflow_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final myCtx = context;
    final cart = Provider.of<Cart>(context,
        listen: false); //*non mi interessano i cambiamenti nel cart qui
    final product = Provider.of<Product>(context,
        listen:
            false); //*se non ascolto più se cambia il cambiamento lo vedrò la prossima volta che entro in questa pagina
    final formatCurrency = NumberFormat.simpleCurrency();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10)),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id); //e passo argomenti
          },
          child: GridTile(
            footer: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: GridTileBar(
                leading: Consumer<Product>(
                  //* SOLO ICONBUTTON ASCOLTA!
                  //child è quello definito sotto e posso usarlo sapendo che NON CAMBIERA'
                  builder: (context, value, child) => IconButton(
                    // iconSize: 14,
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      //*devo passare il MIO conteext se no è uno definito PRIMA del TEMA
                      color: Theme.of(myCtx).colorScheme.secondary,
                    ), //need to listen a single product
                    onPressed: () async {
                      try {
                        await product
                            .toggleFavoriteStatus(); //!e di conseguenza rebuild!
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }

                      //MA AGGIORNO ANCHE LA GRIGLIA
                      Provider.of<Products>(context,
                              listen: false) //NON MI SERVE ASCOLTARE
                          .refreshProductsList();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: const Text('NEVERE CHANGES!'),
                ),
                trailing: IconButton(
                  // iconSize: 14,
                  tooltip: "add item to the cart",
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    //* stabilisce contatto con lo Scaffold più 'vicino' cioè
                    //* quello che controlla la pagina in cui si trova questo
                    //* widget
                    ScaffoldMessenger.of(context)
                        .hideCurrentSnackBar(); //nascondo eventuali snackbar presenti
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: const Text(
                            'Added item to cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cart.removeSingleItem(product.id);
                              })),
                    );
                  },
                  color: Theme.of(context).colorScheme.secondary,
                ),
                backgroundColor: Colors.black54,
                title: Center(
                  child: EllipsisOverflowText(
                    maxLines: 2,
                    product.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    formatCurrency.format(product.price),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
