import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/product.dart';

import '../providers/products.dart';

//*GESTIONE LOCALE DELLO STATO FINCHè USER NON SUBMIT
class EditProductsScreen extends StatefulWidget {
  static const routeName = '//edit-product';
  const EditProductsScreen({super.key});

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode(); //*gestisce il focus
  final _descriptionFocusNode = FocusNode(); //*gestisce il focus
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>(); //* interazione form-state

  var _isLoading = false;

  var _isInit = true; //inizialmente
  var _isEdit = false;
  //*mappa con valori iniziali (se ho 1 prodotto da editare)
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _editedProduct =
      Product(id: '-1', title: '', description: '', price: 0.0, imageUrl: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('jpg'))) {
        return;
      }

      //*lost focus: update!
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //* run before render
    if (_isInit) {
      late final String productId;
      final argument = ModalRoute.of(context)!.settings.arguments;
      if (argument != null) {
        _isEdit = true; //* ho già un id
        productId = argument as String;
        //CERCO IL PRODOTTO
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false; //prossima esecuzione non gira ll'if

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose(); //*se no consuma memoria
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl); //** rimuovo listener */
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate(); //* validazione
    if (!isValid!) {
      return; //non salvo
    }
    //SUBMIT
    _form.currentState?.save();
    setState(() {
      _isLoading = true; //*e rebuild widgets
    });
    //*is edit or add
    if (_isEdit) {
      //EDIT
      Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false; //FINITO
      });
      Navigator.of(context).pop(); //*PER ORA TORNO SUBITO INDIETRO (no http)
    } else {
      print("ADDING async");
      try {
        final added = await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("An error occured!"),
            content: const Text("Something went wrong!"),
            actions: [
              TextButton(
                  onPressed: (() {
                    Navigator.of(context).pop(); //chiudo
                  }),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
            ],
          ),
        );
      } finally {
        //*eseguo comunque
        setState(() {
          _isLoading = false; //*FINITO!
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Product' : 'Add a new Product'),
          actions: [
            IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //*listView "perde" se fuori da schermo
                        //* anche un Container o SingleChildScrollable... con una Column va
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: _initValues['title'],
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          textInputAction:
                              TextInputAction.next, //*move to next input
                          onFieldSubmitted: (value) {
                            // _form.currentState?.validate();
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          }, //*passa al price
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a value.';
                            }
                            return null; //* null: input is correct se no return l'errore
                          },
                          onSaved: (newValue) {
                            //*quando il form viene salvato
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: newValue!,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: _initValues['price'],
                          decoration: const InputDecoration(
                            labelText: 'Price',
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please eneter a valid number.';
                            }
                            if (double.parse(value) <= 0.0) {
                              return 'Please a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            //*quando il form viene salvato
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(newValue!),
                                imageUrl: _editedProduct.imageUrl,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          }, //*passa al price
                          textInputAction:
                              TextInputAction.next, //*move to next input
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: _initValues['description'],
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 3, //* long input
                          focusNode: _descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          textInputAction:
                              TextInputAction.next, //*move to next input
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 10) {
                              return 'Should be at least 10 characters long.';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            //*quando il form viene salvato
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: newValue!,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? const Center(
                                      child: Text(
                                      'Enter a URL',
                                    ))
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: 'Image URL',
                                  suffixIcon: IconButton(
                                    onPressed: _imageUrlController.clear,
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,

                                onFieldSubmitted: (value) {
                                  _saveForm(); //onFieldSub expect a String input (value)
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an image URL';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  if (!value.endsWith('.jpeg') &&
                                      !value.endsWith('.png') &&
                                      !value.endsWith('jpg')) {
                                    return 'Please enter a valid image URL';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  //*quando il form viene salvato
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      price: _editedProduct.price,
                                      imageUrl: newValue!,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                                // onEditingComplete: () {
                                //   setState(
                                //       () {}); //**serve per usare l'url appena digitato forzando il rebuild */
                                // },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
