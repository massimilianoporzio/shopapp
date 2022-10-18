import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/env/env.dart';

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
    final url = Uri.https(host, "v1/accounts:signUp", queryParams);

    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          'email': email.trimRight(),
          'password': password,
          'returnSecureToken': true
        }));
    print(json.decode(response.body));
  }
}
