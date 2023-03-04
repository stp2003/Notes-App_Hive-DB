import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:notes_app_hive/constants/colors.dart';
import 'package:notes_app_hive/models/notes_model.dart';
import 'package:notes_app_hive/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //** widget binding ->
  WidgetsFlutterBinding.ensureInitialized();

  //** getting directory ->
  var directory = await getApplicationDocumentsDirectory();

  //** init hive ->
  Hive.init(directory.path);

  //** registering adaptor made by hive-generator ->
  Hive.registerAdapter(NotesModelAdapter());

  //** open box ->
  await Hive.openBox<NotesModel>('notes');

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notes Hive App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
      ),
      home: const HomeScreen(),
    );
  }
}
