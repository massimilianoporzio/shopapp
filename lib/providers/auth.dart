import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  Timer? _authTimer;

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

  String? get userId {
    return _userId;
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
        _autoLogout(); //*start the timer
        //* STORE TOKEN
        notifyListeners(); //REBUILD!
        final prefs =
            await SharedPreferences.getInstance(); //return a Future so await
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String()
        });
        //store user data on device (not memory!)
        prefs.setString('userData', userData);
      }
    } catch (error) {
      //!firebase risponde code 200 ma dentro può esserci errore
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false; //*automaticalluy wrapped in a future because of async
    }
    final extractedUserDataString = prefs.getString('userData');
    if (extractedUserDataString != null) {
      final extracedUserData =
          json.decode(extractedUserDataString) as Map<String, dynamic>;
      final expiryDate = DateTime.parse(extracedUserData['expiryDate']);
      if (expiryDate.isBefore(DateTime.now())) {
        return false; //già scaduto
      }
      _token = extracedUserData['token'];
      _userId = extracedUserData['userId'];
      _expiryDate = expiryDate;
      notifyListeners();
      _autoLogout(); //set again the timer
      return true;
    }
    return false; //if prefs userData is NULL
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      //* se clicco su logout spengo e annullo il timer
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    //* rimuovo da prefs
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData'); // remove only userData
    prefs.clear(); //rimouve TUTTO
  }

  void _autoLogout() {
    if (_authTimer != null) {
      //* se c'è già un time lo spengo
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
