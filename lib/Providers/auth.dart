import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
    int  expiretime=0;
    String token='';

  Future authorization(String email, String password) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA5AiWlQnf5camfvpt2A6FV6l65BZiM-dI';
    
    final response = await http.post(Uri.parse(url),
        body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}));
     final extracted=jsonDecode(response.body);
     print('attit dsdsdsdsd           ${extracted['idToken']}');
    var f = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception('error');
    }
  }
  Future signWithPassword(String email, String password) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA5AiWlQnf5camfvpt2A6FV6l65BZiM-dI';
    final response = await http.post(Uri.parse(url),
        body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}));

    print(response.statusCode);
    
    if (response.statusCode != 200) {
      throw Exception('error');
    } else {
      var extractedData = jsonDecode(response.body);
      int k=int.parse(extractedData['expiresIn']);
      expiretime = DateTime.now().second +  k ;
      token=extractedData['idToken'];
      print(' lol  $token');
    }
    notifyListeners();
  }
}
