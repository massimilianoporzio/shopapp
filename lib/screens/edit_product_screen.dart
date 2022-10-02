import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';

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

  var _editedProduct =
      Product(id: '-1', title: '', description: '', price: 0.0, imageUrl: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
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
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose(); //*se no consuma memoria
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl); //** rimuovo listener */
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    //SUBMIT
    _form.currentState?.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price.toString());
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //*listView "perde" se fuori da schermo
                  //* anche un Container o SingleChildScrollable... con una Column va
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    textInputAction: TextInputAction.next, //*move to next input
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    }, //*passa al price
                    onSaved: (newValue) {
                      //*quando il form viene salvato
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onSaved: (newValue) {
                      //*quando il form viene salvato
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue!),
                          imageUrl: _editedProduct.imageUrl);
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    }, //*passa al price
                    textInputAction: TextInputAction.next, //*move to next input
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 3, //* long input
                    focusNode: _descriptionFocusNode,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.next, //*move to next input
                    onSaved: (newValue) {
                      //*quando il form viene salvato
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl);
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
                            border: Border.all(width: 1, color: Colors.grey)),
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
                          decoration:
                              const InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (value) {
                            _saveForm(); //onFieldSub expect a String input (value)
                          },
                          onSaved: (newValue) {
                            //*quando il form viene salvato
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue!);
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
