import 'package:flutter/material.dart';
import 'package:notes/data/blocs/bloc_provider.dart';
import 'package:notes/data/blocs/notes_bloc.dart';
import 'package:notes/views/view_notes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: BlocProvider(
        bloc: NotesBloc(), 
        child: NotesPage(title: 'Notes',)
      ),
    );
  }
}

