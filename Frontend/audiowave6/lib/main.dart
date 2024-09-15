import 'package:audiowave6/Helpers/GeneralHelpers/AppBar.dart';
import 'package:audiowave6/Helpers/GeneralHelpers/BackGround.dart';
import 'package:audiowave6/Helpers/GeneralHelpers/SizedBoxes.dart';
import 'package:audiowave6/Home.dart';
import 'package:audiowave6/Register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    );
  }
}
