import 'package:flutter/material.dart';

Widget BG1 () {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/BG1.jpg'),
        fit: BoxFit.fill,),
    ),
  );
}