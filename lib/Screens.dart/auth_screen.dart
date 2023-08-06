import 'package:flutter/material.dart';
import 'package:functional_test/Providers/auth.dart';
import 'package:provider/provider.dart';

enum state { signup, login }

extension on state {
  Widget get Visual {
    switch (this) {
      case state.login:
        return const Padding(padding: EdgeInsets.only(top: 0));
      case state.signup:
        return TextFormField(
          decoration: const InputDecoration(hintText: 'Confirm Password'),
        );
    }
  }

  String get buttonText {
    switch (this) {
      case state.login:
        return 'Login';
      case state.signup:
        return 'Sign up';
    }
  }

  String get subtitle {
    switch (this) {
      case state.login:
        return 'Sign up Instead';

      case state.signup:
        return 'Login Instead';
    }
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var loadedData = false;
  state f = state.signup;

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    TextEditingController conpass = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: const Text('USER AUTHENTICATION')),
        body: loadedData
            ? const Align(alignment: Alignment.center, child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200, left: 30, right: 30),
                      child: Card(
                        child: Form(
                            child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(hintText: 'Enter Email'),
                              controller: email,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(hintText: 'Enter Password'),
                              controller: pass,
                            ),
                            f.Visual,
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      loadedData = true;
                                    });
                                    if (f == state.signup) {
                                      await Provider.of<Auth>(context, listen: false)
                                          .authorization(email.text, pass.text);
                                      setState(() {
                                        loadedData = false;
                                        f = state.login;
                                      });
                                    } else {
                                      await Provider.of<Auth>(context, listen: false)
                                          .signWithPassword(email.text, pass.text);
                                      setState(() {});
                                    }
                                  } catch (e) {
                                    setState(() {
                                      loadedData = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text("Alert Dialog Box"),
                                            content:
                                                const Text("You have raised a Alert Dialog Box"),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Text("okay"),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text(f.buttonText)),
                            GestureDetector(
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (f == state.signup) {
                                        f = state.login;
                                      } else {
                                        f = state.signup;
                                      }
                                    });
                                  },
                                  child: Text(f.subtitle)),
                            )
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
