import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:functional_test/Providers/Product.dart';
import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  List<Product> productsl = [];

  bool favfilter = false;
  String Register='';

  List<Product> get listing {
    if (favfilter == true) {
      List<Product> t = [];
      for (int i = 0; i < productsl.length; i++) {
        if (productsl[i].isFavourite) {
          t.add(productsl[i]);
        }
      }
      return t;
    } else {
      return productsl;
    }
  }

  ///fetching Data from future or firebase
  Future fetchDataDatabase(String token) async {
    print('dsdsdsd   $token');
    Register=token;
    //data fetching
    final response = await http.get(
      Uri.parse('https://shop-app-63690-default-rtdb.firebaseio.com/products.json?auth=$token'),
    );
    String f=token.substring(0,4);
    final response1=http.get( Uri.parse('https://shop-app-63690-default-rtdb.firebaseio.com/user/f/?auth=$token'));
    //final extracteddata1=response1[''];
    print(response.statusCode);
    List<Product> loadedData = [];
    final extractedData = jsonDecode(response.body);
    print(extractedData);
    extractedData.forEach((key, prodData) {
      loadedData.add(Product(
          id: key,
          url: prodData['url'],
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
          isFavourite: prodData['favourite']));
    });
    productsl = loadedData;
    notifyListeners();
    return response;
  }

  void favouriteFilter() {
    favfilter = true;
    notifyListeners();
  }

  void selectAll() {
    favfilter = false;
    notifyListeners();
  }

  ///Update Ui and database of application
  Future updateDatabaseAndUi(
      String title, String price, String description, String url, String id) async {
    var response = await http.patch(
        Uri.parse('https://shop-app-63690-default-rtdb.firebaseio.com/products/$id.json?auth=$Register'),
        body: json.encode(
            {'description': description, 'title': title, 'price': int.parse(price), 'url': url}));
    print(response.statusCode);
    for (int i = 0; i < productsl.length; i++) {
      if (productsl[i].id == id) {
        productsl[i].title = title;
        productsl[i].price = int.parse(price);
        productsl[i].description = description;
        productsl[i].url = url;
        break;
      }
    }
    notifyListeners();
  }

  // adding product into list async function
  Future<void> addingDatabase(String title, String description, String price, String url) async {
    var t = int.parse(price);

    ///we have  have used post api for pushing data to database
  final Url = 'https://shop-app-63690-default-rtdb.firebaseio.com/products.json?auth=$Register';

    var response = await http.post(Uri.parse(Url),
        body: jsonEncode(<String, dynamic>{
          'id': DateTime.now().second,
          'url': url,
          'title': title,
          'price': t,
          'description': description,
          'favourite': false,
        }));

    print(response.body);
    if (response.statusCode == 200) {
      Product obj = Product(
          id: DateTime.now().second.toString(),
          url: url,
          title: title,
          price: t,
          description: description,
          isFavourite: false);
      productsl.add(obj);
      notifyListeners();
    } else {
      throw Exception('error');
    }
  }

  Product displayDetails(String id) {
    for (int i = 0; i < productsl.length; i++) {
      if (productsl[i].id == id) {
        return productsl[i];
      }
    }
    throw {'dsdsds'};
  }

  //delete function using http call for deleting data from databases
  Future delete(String id) async {
    final response = await http
        .delete(Uri.parse('https://shop-app-63690-default-rtdb.firebaseio.com/products/$id.json?auth=$Register'));

    if (response.statusCode == 200) {
      for (int i = 0; i < productsl.length; i++) {
        if (productsl[i].id == id) {
          productsl.removeAt(i);
          break;
        }
      }
      notifyListeners();
    } else {
      throw 'fdfdfd';
    }
  }
}
