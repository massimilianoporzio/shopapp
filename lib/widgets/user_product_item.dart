import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.id});

  @override
  Widget build(BuildContext context) {
    //* lo definisco qui per usarlo nelle Future se no se lo creo dentro un async
    //* non funziona
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                //*vado su pagina Edit/Add
                //* metto id del prodotto negli argomenti! cosi la pagina sa se add o edit
                Navigator.of(context)
                    .pushNamed(EditProductsScreen.routeName, arguments: id);
              },
              color: Theme.of(context).colorScheme.primary),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffoldMessenger.showSnackBar(const SnackBar(
                    content: Text(
                  'Deleting failed!',
                  style: TextStyle(fontSize: 18),
                )));
              }
            },
            color: Theme.of(context).colorScheme.error,
          ),
        ]),
      ), //*NetworkImage è l'oggetto che restituisce un'immagine
    );
  }
}
