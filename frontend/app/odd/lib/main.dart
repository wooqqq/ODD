import 'package:flutter/material.dart';
import 'modules/home/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Freesentation'
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}