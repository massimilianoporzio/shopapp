import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

import 'providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //*uso 'value" ma il best è con
        // * ChangeNotifierProvider(create: (context) => Products(),)
        //* value mi aiuta con liste e wisget che vengono riusati (entrano / escono da schermo)
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart())
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange)),
        home: const ProductsOverviewScreen(), //deve ascoltare Products
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen() //deve ascoltare Products
        },
      ),
    );
  }
}
