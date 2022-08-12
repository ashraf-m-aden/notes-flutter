import 'package:notes/services/crud/notes_service.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants/db-constants.dart';
import 'crud_exceptions.dart';

class DbService {
  Database? database;
  DbService._sharedInstance();

  static final DbService _shared = DbService._sharedInstance();
  factory DbService() => _shared;
  Future<void> ensureDBisOpen() async {
    try {
      open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Database getDbOrThrow() {
    final db = database;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = database;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      database = null;
    }
  }

  Future<void> open() async {
    if (database != null) {
      throw DatabaseAlreadyOpenException();
    } else {
      try {
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        final db = await openDatabase(dbPath);
        database = db;
// create user table and note table
        await db.execute(createUserTable);
        await db.execute(createNoteTable);

        await NoteService().cacheNotes();
      } on MissingPlatformDirectoryException {
        throw UnableToGetDocumentDirectoryException();
      }
    }
  }
}
