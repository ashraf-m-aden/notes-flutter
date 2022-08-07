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
        title: Text('Login'),
      ),
      body: Column(
        children: [
          const Text('Bonjour, veuillez vous connecter.'),
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: "Please your email"),
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: true,
            autocorrect: false,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Please your password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              print("its working");
              await login(email, password, context);
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text('Pas encore enregistrer? Fais le ici!'))
        ],
      ),
    );
  }
}

login(email, password, context) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      default:
        print(e);
    }
  }
}
