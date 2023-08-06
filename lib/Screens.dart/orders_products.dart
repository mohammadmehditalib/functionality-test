import 'package:flutter/material.dart';
import 'package:functional_test/Providers/products.dart';
import 'package:functional_test/Screens.dart/add_product.dart';
import 'package:functional_test/Screens.dart/edit_product.dart';
import 'package:functional_test/Screens.dart/productDetails.dart';
import 'package:provider/provider.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key, required this. token});
  
  final String token;


  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  bool _loadingstate = false;

  @override
  Widget build(BuildContext context) {
    final cartdata = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PRODUCTS'),
        actions: [
          GestureDetector(
            child: const Icon(Icons.add),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProduct()));
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchDataDatabase(widget.token),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final productsl1 = cartdata.listing;
            return Consumer<Products>(
              builder: (context, value, child) {
                return RefreshIndicator(
                  onRefresh: () {
                    return Future(() {
                      setState(() {});
                    });
                  },
                  child: _loadingstate
                      ? const Align(alignment: Alignment.center, child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetails(id:productsl1[index].id)));
                              },
                              child: ListTile(
                                  leading: Image.asset(productsl1[index].url),
                                  title: Text(productsl1[index].description),
                                  visualDensity: const VisualDensity(vertical: -4),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 200),
                                    child: GestureDetector(
                                      child: const Icon(Icons.edit),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    EditProduct(id: productsl1[index].id)));
                                      },
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _loadingstate = true;
                                        });
                                        await cartdata.delete(productsl1[index].id);
                                        setState(() {
                                          _loadingstate = false;
                                        });
                                      },
                                      child: const Icon(Icons.delete_outline))),
                            );
                          },
                          itemCount: productsl1.length,
                        ),
                );
              },
            );
          } else {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
