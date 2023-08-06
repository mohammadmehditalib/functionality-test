import 'package:flutter/material.dart';
import 'package:functional_test/Providers/auth.dart';
import 'package:functional_test/Providers/products.dart';
import 'package:functional_test/Screens.dart/auth_screen.dart';
import 'package:functional_test/Screens.dart/orders_products.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Auth())
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.expiretime>DateTime.now().second? OrderProduct(token: auth.token):const AuthScreen(),
          );
        },
      ),
    );
}
}

