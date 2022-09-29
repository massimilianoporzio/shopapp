import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  // final List<Product> loadedProducts =;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context,
    //     listen:
    //         false); //* mi interessa solo una volta in fase di costruzione della griglia di prodotti
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                switch (selectedValue) {
                  case FilterOptions.Favorites:
                    // productsContainer.showFavoritesOnly();//*solo in caso di filtro GLOBALE
                    _showOnlyFavorites = true;
                    break;
                  case FilterOptions.All:
                    // productsContainer.showAll(); //*solo in caso di filtro GLOBALE
                    _showOnlyFavorites = false;
                    break;
                  default:
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text('Only Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.All,
                  child: Text('Show All'),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: ((context, cart, ch) => Badge(
                  value: cart.itemsCount.toString(),
                  child: ch!, //non rebuild il child!
                )),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ProductsGrid(showFavs: _showOnlyFavorites),
    );
  }
}
