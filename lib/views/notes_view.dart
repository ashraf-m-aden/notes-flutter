import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer' as devtools;

import 'package:notes/constants/routes.dart';

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

Future<bool> showLogOutDialog(BuildContext context) {
  // c'est une promise (futur) qui va retourner un bool grace a showDialog
  return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('log out'),
              content: const Text('Etes vous sur de vous deconnecter'),
              actions: [
                TextButton(
                  onPressed: () {
                    devtools.log('Yes');
                    Navigator.of(context).pop(
                        true); // apparemment ca return true, je ne sais pas encore pkw on peut juste pas faire "return true"
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    devtools.log('Cancel');
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          })
      .then((value) =>
          value ??
          false); // c'est au cas ou l'utilisateur touche les touches d'en bas et n'y repond pas
}
