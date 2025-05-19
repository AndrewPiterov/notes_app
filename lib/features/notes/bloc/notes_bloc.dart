import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note_model.dart';

sealed class NoteEvent {}

// states
sealed class NoteState {}

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
  NotesBloc() : super([]) {
    on<NewNoteCreated>((event, emit) {
      emit([...state, event.note]);
    });

    on<NoteUpdated>((event, emit) {
      final updatedNotes =
          state.map((note) {
            if (note.id == event.note.id) {
              return event.note;
            }
            return note;
          }).toList();
      emit(updatedNotes);
    });

    on<NoteDeleted>((event, emit) {
      final updatedNotes =
          state.where((note) => note.id != event.note.id).toList();
      emit(updatedNotes);
    });
  }
}
