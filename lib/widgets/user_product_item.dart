import 'package:flutter/material.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

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
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
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
            onPressed: () {},
            color: Theme.of(context).colorScheme.error,
          ),
        ]),
      ), //*NetworkImage è l'oggetto che restituisce un'immagine
    );
  }
}
