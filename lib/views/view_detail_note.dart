import 'package:flutter/material.dart';
import 'package:notes/data/blocs/bloc_provider.dart';
import 'package:notes/data/blocs/view_note_bloc.dart';
import 'package:notes/models/note_model.dart';

class ViewNotePage extends StatefulWidget {

  final Note note;

  const ViewNotePage({Key key, this.note}) : super(key: key);
  
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {

  ViewNoteBloc _viewNoteBloc;
  TextEditingController _noteController = new TextEditingController();

  @override
  void initState() {
    _viewNoteBloc = BlocProvider.of<ViewNoteBloc>(context);
    _noteController.text = widget.note.contents;
    super.initState();
  }

  void _saveNote() async {
    widget.note.contents = _noteController.text;

    _viewNoteBloc.inSaveNote.add(widget.note);
  }

  void _deleteNote() async {
    _viewNoteBloc.inDeleteNote.add(widget.note.id);

    _viewNoteBloc.deleted.listen((deleted) {
      if(deleted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note' + widget.note.id.toString()),
        actions: [
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: _saveNote
          ),
          IconButton(
            icon: Icon(Icons.delete), 
            onPressed: _deleteNote
          ),
        ],
      ),
      body: Container(
        child: TextField(
          controller: _noteController,
          maxLines: null,
        ),
      ),
    );
  }
}