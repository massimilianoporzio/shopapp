import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true; //*mi server in didchangedep per fare fetch una sola volta
  var _isLoading = false;
  // final List<Product> loadedProducts =;

  @override
  void initState() {
    //* fetch data when loaded
    //*works only inf listen=false
    // Provider.of<Products>(context).fetchAndSetProducts();
    super.initState();
  }

  Future<void> showErrorDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("An error occured!"),
        content: const Text("Something went wrong."),
        actions: [
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop(); //chiudo
              }),
              child: Text(
                'OK',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    //*run multiple items!!!! so..
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Products>(context).fetchAndSetProducts().then((_) {
          setState(() {
            _isLoading = false; //*SOLO THEN!
          });
        }).onError((error, stackTrace) {
          showErrorDialog(context);
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        showErrorDialog(context);
        _isLoading = false;
      }
    }
    _isInit = false;
    // Provider.of<Products>(context).fetchAndSetProducts();
    super.didChangeDependencies();
  }

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
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : ProductsGrid(showFavs: _showOnlyFavorites),
    );
  }
}
