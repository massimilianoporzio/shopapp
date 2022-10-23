import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

import 'providers/orders.dart';
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
        //* NON SONO I PROVIDER A CAUSARE REBUILD MA I LISTENERS NEI VARI WIDGET
        // ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Auth()),

        ChangeNotifierProvider.value(value: Cart()),
        // ChangeNotifierProvider.value(value: Orders()),
        //* provider che dipende da altro provider
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) =>
                Products(null, [], null), //*token nullo e lista di item vuota
            update: (context, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId)),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null, [], null),
          update: (context, auth, previousOrders) => Orders(auth.token,
              previousOrders == null ? [] : previousOrders.orders, auth.userId),
        )
      ],
      //*rebuild only this child
      child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.unknown
                  },
                ),
                debugShowCheckedModeBanner: false,
                title: 'MyShop',
                theme: ThemeData(
                    scaffoldBackgroundColor: Colors.white,
                    fontFamily: 'Lato',
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                            .copyWith(secondary: Colors.deepOrange)),
                //  home: const ProductsOverviewScreen(), //deve ascoltare Products
                home: auth.isAuth
                    ? const ProductsOverviewScreen()
                    : const AuthScreen(), //!PRIMA CI SI AUTENTICA

                routes: {
                  AuthScreen.routeName: (context) => const AuthScreen(),
                  ProductsOverviewScreen.routeName: (context) =>
                      const ProductsOverviewScreen(),
                  ProductDetailScreen.routeName: (context) =>
                      const ProductDetailScreen(), //deve ascoltare Products
                  CartScreen.routeName: ((context) => const CartScreen()),
                  OrdersScreen.routeName: ((context) => const OrdersScreen()),
                  UserProductsScreen.routeName: (context) =>
                      const UserProductsScreen(),
                  EditProductsScreen.routeName: (context) =>
                      const EditProductsScreen()
                },
              )),
    );
  }
}
