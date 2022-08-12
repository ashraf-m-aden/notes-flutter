import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<void> ShowDynamicDialog(

    /// le dialogue pour afficher n'importe quel titre et text
    BuildContext context,
    String title,
    String text) {
  // c'est une promise (futur) qui va retourner un bool grace a showDialog
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Okay"),
            ),
          ],
        );
      });
}

Future<bool> showLogOutDialog(BuildContext context) {
  // dialog pour logout
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
                    Navigator.of(context).pop(
                        true); // apparemment ca return true, je ne sais pas encore pkw on peut juste pas faire "return true"
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
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

Future<bool> showDeleteDialog(BuildContext context) {
  // dialog pour logout
  // c'est une promise (futur) qui va retourner un bool grace a showDialog
  return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete?'),
              content: const Text('Etes vous sur de vouloir supprimer?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                        true); // apparemment ca return true, je ne sais pas encore pkw on peut juste pas faire "return true"
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
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
