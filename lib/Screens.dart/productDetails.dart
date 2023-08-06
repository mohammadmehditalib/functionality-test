import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final productsl1 = productData.productsl;
    String t = '';
    for (int i = 0; i < productsl1.length; i++) {
      if (productsl1[i].id == id) {
        t = productsl1[i].description;
        break;
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(t)),
    );
  }
}
