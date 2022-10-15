import 'package:flutter/material.dart';
import 'package:montyhall/game_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => ClickOrInside()))
      ],
      child: MaterialApp(
        title: 'MontyHall',
        home: GamePage(),
      ),
    );
  }
}
