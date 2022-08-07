import 'package:flutter/material.dart';
import 'package:notes/views/auth_check.dart';
import 'package:notes/views/login_views.dart';
import 'package:notes/views/notes_view.dart';
import 'package:notes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    home: const Auth(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/notes/': (context) => const NotesView()
    },
  ));
}
