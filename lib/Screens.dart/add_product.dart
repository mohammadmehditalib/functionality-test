import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';


import '../Providers/products.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ///future builder
  bool status = false;
  bool _loadingstate = false;
  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context, listen: false);
    TextEditingController title = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController url = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('ADD NEW PRODUCTS DETAILS'),
          //actions: const [Icon(Icons.save)],
        ),
        body: _loadingstate
            ? const Align(alignment: Alignment.center, child: CircularProgressIndicator())
            : Form(
                child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Title'),
                    controller: title,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Price'),
                    controller: price,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Description'),
                    controller: description,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Add url'),
                    controller: url,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                _loadingstate = true;
                              });
                              await products.addingDatabase(
                                  title.text, description.text, price.text, url.text);
                              setState(() {
                                Navigator.pop(context);
                                _loadingstate = true;
                              });
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: const Text("Alert Dialog Box"),
                                      content: const Text("You have raised a Alert Dialog Box"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.popUntil(context, (route) => route.isFirst);
                                            },
                                            child: Container(
                                              color: Colors.green,
                                              padding: const EdgeInsets.all(14),
                                              child: const Text("okay"),
                                            )),
                                      ]);
                                },
                              );
                            }
                          },
                          child: const Text('Add the details')))
                ],
              )));
  }
}
