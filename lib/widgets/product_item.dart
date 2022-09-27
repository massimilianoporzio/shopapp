import 'package:ellipsis_overflow_text/ellipsis_overflow_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {super.key,
      required this.id,
      required this.title,
      required this.imageUrl,
      required this.price});

  final String id;
  final String title;
  final String imageUrl;
  final double price;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10)),
        child: GridTile(
          footer: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: GridTileBar(
              leading: IconButton(
                // iconSize: 14,
                icon: const Icon(Icons.favorite),
                onPressed: () {},
                color: Theme.of(context).colorScheme.secondary,
              ),
              trailing: IconButton(
                // iconSize: 14,
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
                color: Theme.of(context).colorScheme.secondary,
              ),
              backgroundColor: Colors.black54,
              title: Center(
                child: EllipsisOverflowText(
                  maxLines: 2,
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
              subtitle: Center(
                child: Text(
                  formatCurrency.format(price),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
