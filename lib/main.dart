import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';

import 'providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return Products(); //unica istanza a cui tutti gli interessati ascoltano
      }, //qui definisco il provider
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.purple.shade100,
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange)),
        home: ProductsOverviewScreen(), //deve ascoltare Products
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen() //deve ascoltare Products
        },
      ),
    );
  }
}
