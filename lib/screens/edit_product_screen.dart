import 'package:flutter/material.dart';

//*GESTIONE LOCALE DELLO STATO FINCHè USER NON SUBMIT
class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({super.key});

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: const Center(child: Text('ADD/EDIT')),
    );
  }
}
