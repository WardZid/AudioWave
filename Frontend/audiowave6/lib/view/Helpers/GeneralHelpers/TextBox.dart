import 'package:flutter/material.dart';


Widget TextBoxC (TextEditingController tec, String hint) {
  return Padding(
  padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
  child: Container(
    color: Colors.white,
    child: TextField(
      controller: tec,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hint
      ),),),);
}