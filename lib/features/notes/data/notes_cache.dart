import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:note_app/features/notes/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class INotesCache {
  Future<List<NoteModel>> getNotes();
  Future<void> saveNotes(List<NoteModel> notes);
}

class SharedPreferencesNotesCache implements INotesCache {
  SharedPreferencesNotesCache({SharedPreferences? sharedPreferences})
    : _sharedPreferences = sharedPreferences ?? GetIt.I<SharedPreferences>();

  final SharedPreferences _sharedPreferences;

  final List<NoteModel> _notes = [];

  @override
  Future<List<NoteModel>> getNotes() async {
    final String? notesString = _sharedPreferences.getString('notes');
    if (notesString != null) {
      final List<NoteModel> notes = List<NoteModel>.from(
        json.decode(notesString).map((x) => NoteModel.fromJson(x)),
      );
      _notes.clear();
      _notes.addAll(notes);
    }
    return _notes;
  }

  @override
  Future<void> saveNotes(List<NoteModel> notes) async {
    final String notesString = json.encode(
      List<dynamic>.from(notes.map((x) => x.toJson())),
    );
    await _sharedPreferences.setString('notes', notesString);
    _notes.clear();
    _notes.addAll(notes);
  }
}
