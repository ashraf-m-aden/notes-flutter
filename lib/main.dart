import 'package:flutter/material.dart';
import 'package:notes/views/login_views.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.pink,
    ),
    home: const LoginView(),
  ));
}
