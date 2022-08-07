import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_views.dart';
import 'package:notes/views/notes_view.dart';

import '../firebase_options.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null)
              return const NotesView();
            else
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => const LoginView()));   ca c pour naviguer dans un autre scafold
              return const LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
