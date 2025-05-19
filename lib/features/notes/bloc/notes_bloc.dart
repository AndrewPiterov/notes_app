import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:note_app/features/notes/data/notes_cache.dart';

import '../models/note_model.dart';

sealed class NoteEvent {}

// states
sealed class NoteState {}

final class GetNotesEvent extends NoteEvent {}

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
  final INotesCache _cache;

  NotesBloc({INotesCache? cache})
    : _cache = cache ?? GetIt.I<INotesCache>(),
      super([]) {
    on<GetNotesEvent>(_getNotes);

    on<NewNoteCreated>(_addNewNote);

    on<NoteUpdated>(_updateNote);

    on<NoteDeleted>(_deleteNote);
  }

  FutureOr<void> _deleteNote(NoteDeleted event, Emitter<List<NoteModel>> emit) {
    final updatedNotes =
        state.where((note) => note.id != event.note.id).toList();
    _cache.saveNotes(updatedNotes);
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
    _cache.saveNotes(updatedNotes);
    emit(updatedNotes);
  }

  Future<void> _addNewNote(
    NewNoteCreated event,
    Emitter<List<NoteModel>> emit,
  ) async {
    final newList = [...state, event.note];
    _cache.saveNotes(newList);
    emit(newList);
  }

  Future<void> _getNotes(
    GetNotesEvent event,
    Emitter<List<NoteModel>> emit,
  ) async {
    final notes = await _cache.getNotes();
    emit(notes);
  }
}
