import 'package:flutter/material.dart';
import 'package:functional_test/Providers/products.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final String id;

  const EditProduct({
    super.key,
    required this.id,
  });

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  bool _loadingstate = false;

  @override
  Widget build(BuildContext context) {
    final details = Provider.of<Products>(context, listen: false).displayDetails(widget.id);
    TextEditingController title = TextEditingController(text: details.title.toString());
    TextEditingController price = TextEditingController(text: details.price.toString());

    TextEditingController description = TextEditingController(text: details.description);

    TextEditingController url = TextEditingController(text: details.url);
    return Scaffold(
        appBar: AppBar(
          title: const Text('EDIT DETAILS'),
        ),
        body: _loadingstate
            ? const Align(alignment: Alignment.center, child: CircularProgressIndicator())
            : Form(
                child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
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
                              await Provider.of<Products>(context, listen: false)
                                  .updateDatabaseAndUi(title.text, price.text, description.text,
                                      url.text, widget.id);
                              setState(() {
                                Navigator.pop(context);
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
