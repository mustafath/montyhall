import 'package:flutter/material.dart';
import 'package:montyhall/game_page.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'click.dart';
import 'on_board_screen.dart';

bool isDone = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? result = await preferences.getBool("isDone");
  isDone = result ?? false;
  print(preferences.getBool("isDone"));

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => ClickOrInside())),
      ],
      child: MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          title: 'MontyHall',
          home: !isDone ? OnBoardScreen() : GamePage()),
    );
  }
}
