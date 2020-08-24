import 'dart:async';

import 'package:Notes/data/blocs/bloc_provider.dart';
import 'package:Notes/data/database.dart';
import 'package:Notes/models/note_model.dart';

class NotesBloc implements BlocBase {

  final _notesController = StreamController<List<Note>>.broadcast();

  // Input stream. Add note to stream
  StreamSink<List<Note>> get _inNotes => _notesController.sink;

  // Output stream. Display note
  Stream<List<Note>> get notes => _notesController.stream;

  // Input stream for add new note
  // final _addNoteController = StreamController<Note>.broadcast();
  // StreamSink<Note> get inAddNote => _addNoteController.sink;

  NotesBloc() {
    getNotes();
  }

  @override
  void dispose() {
    _notesController.close();
  }

  void getNotes() async {
    List<Note> notes = await DBProvider.db.getNotes();

    _inNotes.add(notes);
  }

}