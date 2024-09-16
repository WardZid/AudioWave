import 'package:flutter/material.dart';

PreferredSizeWidget AppBarC (BuildContext context, String label, double size) {
  return AppBar(
    title: Text(label, style: TextStyle(fontSize: size),),
    centerTitle: true,
  );
}