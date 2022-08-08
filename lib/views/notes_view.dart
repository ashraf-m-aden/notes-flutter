import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer' as devtools;

import 'package:notes/constants/routes.dart';

import '../utilities/dialogs.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout, profile }

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamed(loginRoute);
                }
                break;
              case MenuAction.profile:
                // TODO: Handle this case.
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile, child: Text('Profil')),
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text('Log out')),
            ];
          })
        ],
      ),
      body: const Text('Hello world'),
    );
  }
}
