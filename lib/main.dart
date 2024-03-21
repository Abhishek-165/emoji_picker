import 'package:emoji_picker/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/shared_preferences.dart';
import 'emoji_picker/presentations/bloc/emoji_picker_bloc.dart';
import 'emoji_picker/presentations/pages/emoji_picker_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await SharedPreferencesEmoji.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<EmojiPickerBloc>(
              create: (context) => getIt<EmojiPickerBloc>(),
            )
          ],
          child: const ShowBottomSheet(),
        ));
  }
}
