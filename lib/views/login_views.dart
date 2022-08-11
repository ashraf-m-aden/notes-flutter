import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/authException.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/dialogs.dart';

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
              const CircularProgressIndicator();
              await login(email, password, context);
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Pas encore enregistrer? Fais le ici!'))
        ],
      ),
    );
  }
}

login(email, password, context) async {
  try {
    await AuthService.firebase().login(
      email: email,
      password: password,
    );
    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
  } on UserNotFoundAuthException {
    ShowDynamicDialog(context, 'Error', 'L\'utilisateur n\'existe pas.');
  } on WrongPasswordAuthException {
    ShowDynamicDialog(context, 'Error', 'Mauvais mot de passe');
  } on GenericAuthException {
    ShowDynamicDialog(context, 'Error', 'Erreur d\'authentification');
  }
}
