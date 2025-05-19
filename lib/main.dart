import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:note_app/features/notes/bloc/notes_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/features.dart';
import 'features/notes/data/notes_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependencies
  GetIt.I.registerSingletonAsync<SharedPreferences>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  });
  await GetIt.I.isReady<SharedPreferences>();
  GetIt.I.registerSingleton<INotesCache>(SharedPreferencesNotesCache());

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc()..add(GetNotesEvent()),
      child: MaterialApp(
        title: 'Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: NoteListPage(),
      ),
    );
  }
}
