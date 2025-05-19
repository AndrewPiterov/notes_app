import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../pages/edit_note_page.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem(this.note, {super.key});

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Text(
              note.content ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              '${note.createdAt}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
