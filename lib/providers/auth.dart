import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/env/env.dart';
import 'package:shopapp/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  final queryParams = {'key': Env.firebase};
  // final host = Platform.isAndroid ? "10.0.2.2:9099" : "127.0.0.1:9099";
  final host = "identitytoolkit.googleapis.com";

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final url = Uri.https(host, "v1/accounts:$urlSegment", queryParams);

    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            'email': email.trimRight(),
            'password': password,
            'returnSecureToken': true
          }));
      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        //* SET THE TOKEN
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
        notifyListeners(); //REBUILD!
      }
    } catch (error) {
      //!firebase risponde code 200 ma dentro può esserci errore
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
