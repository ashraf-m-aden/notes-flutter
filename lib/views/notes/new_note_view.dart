import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/services/crud/users_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final UserService _userService;
  late final TextEditingController _textController;

  Future<DatabaseNote> _createNewNote() async {
    // ici on genere une note vide mais au moins avk l'id du owner
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser;
    final email = currentUser!.user.email;
    final owner = await _userService.getUser(email: email);
    return await _noteService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    // il n'ya pas de bouton sauvegarder, ca sauvegarde auto en quittant la page
    //cette fonction est appelé en quittant la page
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      await _noteService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    // ca c'est pour faire update à chaque fois qu'il y'a ecriture de txte
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    // ici c'est pour coller le text controler et le listener
    _textController.removeListener(
        _textControllerListener); // on efface d'abord au cas où c'est appelé plusieurs fois
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _noteService = NoteService();
    _userService = UserService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // en quittant la page on supprime si ya pas de note,
    ///sinon on sauvegarde, puis on effae le text controller
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New note'),
      ),
      body: FutureBuilder(
        future: _createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote?;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(hintText: 'Start typing...'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
