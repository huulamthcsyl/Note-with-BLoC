import 'dart:async';

import 'package:Notes/data/blocs/bloc_provider.dart';
import 'package:Notes/data/database.dart';
import 'package:Notes/models/note_model.dart';

class ViewNoteBloc implements BlocBase {

  final _addNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inAddNote => _addNoteController.sink;

  final _saveNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inSaveNote => _saveNoteController.sink;

  final _deleteNoteController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteNote => _deleteNoteController.sink;

  final _noteDeletedController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDeleted => _noteDeletedController.sink;
  Stream<bool> get deleted => _noteDeletedController.stream;

  ViewNoteBloc() {
    _addNoteController.stream.listen(_handleAddNote);
    _saveNoteController.stream.listen(_handleSaveNote);
    _deleteNoteController.stream.listen(_handleDeleteNote);
  }

  @override
  void dispose() {
    _saveNoteController.close();
    _deleteNoteController.close();
    _noteDeletedController.close();
    _addNoteController.close();
  }

  void _handleSaveNote(Note note) async {
    await DBProvider.db.updateNote(note);
  }

  void _handleDeleteNote(int id) async {
    await DBProvider.db.deleteNote(id);

    _inDeleted.add(true);
  }

  void _handleAddNote(Note note) async {
    await DBProvider.db.newNote(note);
  }

}