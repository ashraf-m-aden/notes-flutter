import 'package:flutter/material.dart';
import 'package:notes/services/auth/authException.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/dialogs.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          const Text('Bonjour, veuillez vous enregistrer.'),
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: "Please your email"),
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
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

              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                // print(userCredential);
              } on UserNotLoggedInAuthException {
                ShowDynamicDialog(
                    context, 'Error', 'L\'utilisateur n\'est pas connecté.');
              } on WeakPasswordAuthException {
                ShowDynamicDialog(context, 'Error', 'Faible mot de passe');
              } on EmailAlreadyInUseAuthException {
                ShowDynamicDialog(context, 'Error', 'Email deja existant');
              } on InvalidEmailAuthException {
                ShowDynamicDialog(context, 'Error', 'Email erroné');
              } on GenericAuthException {
                ShowDynamicDialog(
                    context, 'Error', 'Erreur d\'authentification');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (route) => false);
              },
              child: const Text('Se connecter'))
        ],
      ),
    );
  }
}
