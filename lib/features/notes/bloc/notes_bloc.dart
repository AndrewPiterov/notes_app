import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:note_app/features/notes/data/notes_cache.dart';

import '../models/note_model.dart';

sealed class NoteEvent {}

// states
sealed class NoteState {}

final class GetNotesEvent extends NoteEvent {}

final class SearchNotesEvent extends NoteEvent {
  SearchNotesEvent(this.query);

  final String query;
}

final class NewNoteCreated extends NoteEvent {
  NewNoteCreated(this.note);

  final NoteModel note;
}

final class NoteUpdated extends NoteEvent {
  NoteUpdated(this.note);

  final NoteModel note;
}

final class NoteDeleted extends NoteEvent {
  NoteDeleted(this.note);

  final NoteModel note;
}

class NotesBloc extends Bloc<NoteEvent, List<NoteModel>> {
  NotesBloc({INotesCache? cache})
    : _cache = cache ?? GetIt.I<INotesCache>(),
      super([]) {
    on<GetNotesEvent>(_getNotes);
    on<SearchNotesEvent>(_filterNotes);
    on<NewNoteCreated>(_addNewNote);
    on<NoteUpdated>(_updateNote);
    on<NoteDeleted>(_deleteNote);
  }

  final INotesCache _cache;

  List<NoteModel> _notes = [];

  FutureOr<void> _filterNotes(
    SearchNotesEvent event,
    Emitter<List<NoteModel>> emit,
  ) async {
    final notes =
        _notes.where((note) {
          if (event.query.isEmpty) {
            return true;
          }
          return ('${note.title}\n${note.content ?? ''}')
              .toLowerCase()
              .contains(event.query.toLowerCase());
        }).toList();
    emit(notes);
  }

  FutureOr<void> _deleteNote(NoteDeleted event, Emitter<List<NoteModel>> emit) {
    final updatedNotes =
        state.where((note) => note.id != event.note.id).toList();
    _updateList(updatedNotes);
    emit(updatedNotes);
  }

  FutureOr<void> _updateNote(NoteUpdated event, Emitter<List<NoteModel>> emit) {
    final updatedNotes =
        state.map((note) {
          if (note.id == event.note.id) {
            return event.note;
          }
          return note;
        }).toList();
    _updateList(updatedNotes);
    emit(updatedNotes);
  }

  Future<void> _addNewNote(
    NewNoteCreated event,
    Emitter<List<NoteModel>> emit,
  ) async {
    final newList = [...state, event.note];
    _updateList(newList);
    emit(newList);
  }

  Future<void> _getNotes(
    GetNotesEvent event,
    Emitter<List<NoteModel>> emit,
  ) async {
    final notes = await _cache.getNotes();
    _notes = notes;
    emit(notes);
  }

  void _updateList(List<NoteModel> notes) {
    _notes = notes;
    _cache.saveNotes(notes);
  }
}
