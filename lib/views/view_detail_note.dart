import 'package:flutter/material.dart';
import 'package:Notes/data/blocs/bloc_provider.dart';
import 'package:Notes/data/blocs/view_note_bloc.dart';
import 'package:Notes/models/note_model.dart';

class ViewNotePage extends StatefulWidget {

  final Note note;

  const ViewNotePage({Key key, this.note}) : super(key: key);
  
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {

  ViewNoteBloc _viewNoteBloc;
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentsController = new TextEditingController();

  @override
  void initState() {
    _viewNoteBloc = BlocProvider.of<ViewNoteBloc>(context);
    _titleController.text = widget.note.title;
    _contentsController.text = widget.note.contents;

    super.initState();
  }

  void _saveNote() async {
    widget.note.title = _titleController.text;
    widget.note.contents = _contentsController.text;

    if(widget.note.id != null) _viewNoteBloc.inSaveNote.add(widget.note);
    else _viewNoteBloc.inAddNote.add(widget.note);

    Navigator.of(context).pop(true);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children:[ 
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Title'
                ),
                maxLines: null,
              ),
              SizedBox(height: 8,),
              Divider(),
              TextField(
                controller: _contentsController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Contents'
                ),
                maxLines: null,
              ),
            ]
          ),
        ),
      ),
    );
  }
}