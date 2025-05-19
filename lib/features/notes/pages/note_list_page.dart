import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/notes/bloc/notes_bloc.dart';
import 'package:note_app/features/notes/widgets/note_list_item.dart';

import '../models/note_model.dart';
import 'edit_note_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              context.read<NotesBloc>().add(SearchNotesEvent(value));
            },
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<NotesBloc, List<NoteModel>>(
              builder: (context, state) {
                final list = state;

                if (list.isEmpty) {
                  return const Center(child: Text('No notes yet'));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final note = list[index];
                    return NoteListItem(key: ValueKey(note.id), note);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditNotePage()),
          );
        },
      ),
    );
  }
}
