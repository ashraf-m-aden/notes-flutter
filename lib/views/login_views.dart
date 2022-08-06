import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController
      _email; //create a variable, late veut dire tu promets de lui assigner une valeur apres
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Se connecter'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  Text('Bonjour, veuillez vous connecter.'),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(hintText: "Please your email"),
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextField(
                    controller: _password,
                    decoration:
                        InputDecoration(hintText: "Please your password"),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      print("its working");
                      await login(email, password);
                    },
                    child: const Text('Login'),
                  ),
                ],
              );
            default:
              return const Text('Loading');
          }
        },
      ),
    );
  }
}

login(email, password) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print(userCredential);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      default:
        print(e);
    }
  }
}
