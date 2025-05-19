import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/notes/bloc/notes_bloc.dart';

import '../models/note_model.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({this.note, super.key});

  final NoteModel? note;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<NotesBloc>().add(NoteDeleted(widget.note!));
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Title cannot be empty')),
                );
                return;
              }

              if (widget.note != null) {
                context.read<NotesBloc>().add(
                  NoteUpdated(
                    widget.note!.copyWith(
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  ),
                );
              } else {
                context.read<NotesBloc>().add(
                  NewNoteCreated(
                    NoteModel(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      content: _contentController.text,
                      createdAt: DateTime.now(),
                    ),
                  ),
                );
              }

              Navigator.pop(context);
            },
            child: Text(widget.note == null ? 'Save' : 'Update'),
          ),
        ],
      ),
    );
  }
}
