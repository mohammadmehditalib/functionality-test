import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  String id;
  String url;
  String title;
  int price;
  String description;
  bool isFavourite;

  Product(
      {required this.id,
      required this.url,
      required this.title,
      required this.price,
      required this.description,
      required this.isFavourite});
////update favourite status on server
  change(String id,String token) async {
    String f=token.substring(0,4);
    print('token        $token');
    isFavourite = !isFavourite;
    notifyListeners();
    final response = await http.patch(
        Uri.parse('https://shop-app-63690-default-rtdb.firebaseio.com/user/$f/$id.json?auth=$token'),
        body: json.encode(
            {'favourite':isFavourite}));
     print('lol        ${response.statusCode}');       
  }
}
