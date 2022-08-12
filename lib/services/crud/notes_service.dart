import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:notes/services/crud/db_service.dart';
import 'package:notes/services/crud/users_service.dart';

import '../../constants/db-constants.dart';
import 'crud_exceptions.dart';

class NoteService {
  final UserService _userService = UserService();
  final DbService _dbService = DbService();
  List<DatabaseNote> _notes = [];
  // c'est pour creer un singleton du service utilisé partt,
  NoteService._sharedInstance();
  static final NoteService _shared = NoteService._sharedInstance();
  factory NoteService() => _shared;
  final _noteStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _noteStreamController.stream;

  Future<void> cacheNotes() async {
    final allNotes = await getAllNote();
    _notes = allNotes.toList();
    _noteStreamController.add(_notes);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();

// make sure user exist in the db
    final dbUser = await _userService.getUser(email: owner.email);

    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = 'Ceci est un test';
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
    });
    final note = DatabaseNote(id: noteId, userId: owner.id, text: text);
    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();

    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _noteStreamController.add(_notes);
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _noteStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    await _dbService.ensureDBisOpen();
    final db = _dbService.getDbOrThrow();
    const text = "Ceci est une mise à jour";
    final updateCount = await db.update(noteTable, {textColumn: text});
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    }
    await cacheNotes();
    final updatedNote = await getNote(id: note.id);
    _notes.removeWhere((note) => note.id == note.id);
    _notes.add(updatedNote);
    _noteStreamController.add(_notes);
    return updatedNote;
  }
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;

  @override
  String toString() {
    return 'Note, ID = $id , userId = $userId , text = $text';
  }

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
