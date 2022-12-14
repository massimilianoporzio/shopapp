import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/http_exception.dart';

import '../providers/auth.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _context = context;
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  //* con uno stateful posso fare animazioni
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  //mixin add method per animazioni
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimantion;
  late Animation<Offset> _slideAnimantion;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heightAnimantion = Tween<Size>(
            begin: const Size(double.infinity, 260),
            end: const Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    //SET A LISTENER TO UPDATE WHENEVER THE CONTANIER HEIGHT IS CHANGED
    // _heightAnimantion.addListener(() {
    //   setState(() {}); //SOLO PER RIGENERARE CON BUILD
    // });
    _slideAnimantion =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose(); //RIMUOVO LISTENERS
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("An error occured!"),
              content: Text(message),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData["password"]!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData["password"]!);
      }
    } on HttpException catch (error) {
      //! solo se l'eccezione ?? la MIA CLASSE
      var errorMessage = 'Athentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This email address is already in use.";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "This is not a valid email address";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Could not find a user with that email";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      //* ALTRE ECCEZ
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false; //* fa sparire lo spinner
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      //SET STATE SOLO A FINE ANIMAZIONE SE NO IL CAMPO confirmPws fa alzare l'altezza subito
      _controller.forward().whenComplete(() => setState(() {
            _authMode = AuthMode.signup;
          })); //START ANIMATION
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse(); //REVERSE ANIMATION
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedBuilder(
          animation: _heightAnimantion,
          //! SOLO IL CONTAINER CAMBIA
          builder: (context, ch) => Container(
              // height: _authMode == AuthMode.signup ? 320 : 260, //SENZA ANIMAZIONE
              height: _heightAnimantion.value.height, //CON ANIMAZIONE
              constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.signup ? 320 : 260),
              width: deviceSize.width * 0.75,
              padding: const EdgeInsets.all(16.0),
              child:
                  ch //NOT RE_RENDERED: ch ?? quello definito in child dele builder
              ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                      // return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  // if (_authMode == AuthMode.signup) ** metto animazione
                  AnimatedContainer(
                    //shrink to 0 se non serve
                    duration: const Duration(milliseconds: 300),
                    constraints: BoxConstraints(
                        //a 0 se login
                        minHeight: _authMode == AuthMode.signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                    child: FadeTransition(
                      opacity: //vuole una animation
                          _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimantion,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        // primary: Theme.of(context).primaryTextTheme.button.color,
                      ),
                      child: Text(
                          _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                    ),
                  TextButton(
                    onPressed: _switchAuthMode,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
