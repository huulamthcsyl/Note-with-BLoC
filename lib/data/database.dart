import 'dart:io';

import 'package:Notes/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'DBNotes.db');

    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (db, version) async {
      await db.execute('''
                CREATE TABLE Notes(
                  id INTEGER PRIMARY KEY,
                  title TEXT DEFAULT '',
                  contents TEXT DEFAULT ''
                )''');
    },);
  }

  newNote(Note note) async {
    final db = await database;
    var res = db.insert('Notes', note.toJson());
    return res;
  }

  getNotes() async {
    final db = await database;
    var res = await db.query('Notes');

    List<Note> notes = res.isNotEmpty ? res.map((e) => Note.fromJson(e)).toList() : [];

    return notes;
  }

  getNote(int id) async {
    final db = await database;
    var res = await db.query('Notes', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Note.fromJson(res.first) : null;
  }

  updateNote(Note note) async {
    final db = await database;
    var res = await db.update('Notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);

    return res;
  }

  deleteNote(int id) async {
    final db = await database;
    await db.delete('Notes', where: 'id = ?', whereArgs: [id]);
  }
}