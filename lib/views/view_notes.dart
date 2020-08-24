import 'package:flutter/material.dart';
import 'package:notes/data/blocs/bloc_provider.dart';
import 'package:notes/data/blocs/notes_bloc.dart';
import 'package:notes/data/blocs/view_note_bloc.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/views/view_detail_note.dart';

class NotesPage extends StatefulWidget {

  final String title;

  const NotesPage({Key key, this.title}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  NotesBloc _notesBloc;

  @override
  void initState() {
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    super.initState();
  }

  void _addNote() async {
    Note note = new Note(contents: '');

    _notesBloc.inAddNote.add(note);
  }

  void _navigateToNote(Note note) async {
    bool update = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          bloc: ViewNoteBloc(), 
          child: ViewNotePage(note: note)
        ),
      )
    );

    if(update != null){
      _notesBloc.getNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: _notesBloc.notes,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<Note> notes = snapshot.data;
                    
                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        Note note = notes[index];

                        return GestureDetector(
                          onTap: () => _navigateToNote(note),
                          child: Container(
                            height: 40,
                            child: Text(
                              'Note' + note.id.toString(),
                              style: TextStyle(
                                fontSize: 18
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}