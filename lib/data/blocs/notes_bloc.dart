import 'dart:async';

import 'package:notes/data/blocs/bloc_provider.dart';
import 'package:notes/data/database.dart';
import 'package:notes/models/note_model.dart';

class NotesBloc implements BlocBase {

  final _notesController = StreamController<List<Note>>.broadcast();

  // Input stream. Add note to stream
  StreamSink<List<Note>> get _inNotes => _notesController.sink;

  // Output stream. Display note
  Stream<List<Note>> get notes => _notesController.stream;

  // Input stream for add new note
  final _addNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inAddNote => _addNoteController.sink;

  NotesBloc() {
    getNotes();

    _addNoteController.stream.listen(_handleAddNote);
  }

  @override
  void dispose() {
    _notesController.close();
    _addNoteController.close();
  }

  void getNotes() async {
    List<Note> notes = await DBProvider.db.getNotes();

    _inNotes.add(notes);
  }

  void _handleAddNote(Note note) async {
    await DBProvider.db.newNote(note);

    getNotes();
  }

}