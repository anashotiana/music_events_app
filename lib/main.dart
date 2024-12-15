import 'package:flutter/material.dart';
import 'search_screen.dart';

void main() {
  runApp(const MusicEventsApp());
}

class MusicEventsApp extends StatelessWidget {
  const MusicEventsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Events Finder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SearchScreen(),
    );
  }
}
