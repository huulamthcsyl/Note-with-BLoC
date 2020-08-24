import 'package:flutter/material.dart';
import 'package:Notes/data/blocs/bloc_provider.dart';
import 'package:Notes/data/blocs/notes_bloc.dart';
import 'package:Notes/data/blocs/view_note_bloc.dart';
import 'package:Notes/models/note_model.dart';
import 'package:Notes/views/view_detail_note.dart';

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
    Note note = new Note(title: '', contents: '');

    _navigateToNote(note);
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
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              note.contents,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54
                              ),
                            ),
                          ],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}