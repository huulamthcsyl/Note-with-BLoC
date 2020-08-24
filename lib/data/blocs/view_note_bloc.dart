import 'dart:async';

import 'package:notes/data/blocs/bloc_provider.dart';
import 'package:notes/data/database.dart';
import 'package:notes/models/note_model.dart';

class ViewNoteBloc implements BlocBase {

  final _saveNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inSaveNote => _saveNoteController.sink;

  final _deleteNoteController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteNote => _deleteNoteController.sink;

  final _noteDeletedController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDeleted => _noteDeletedController.sink;
  Stream<bool> get deleted => _noteDeletedController.stream;

  ViewNoteBloc() {
    _saveNoteController.stream.listen(_handleSaveNote);
    _deleteNoteController.stream.listen(_handleDeleteNote);
  }

  @override
  void dispose() {
    _saveNoteController.close();
    _deleteNoteController.close();
    _noteDeletedController.close();
  }

  void _handleSaveNote(Note note) async {
    await DBProvider.db.updateNote(note);
  }

  void _handleDeleteNote(int id) async {
    await DBProvider.db.deleteNote(id);

    _inDeleted.add(true);
  }

}