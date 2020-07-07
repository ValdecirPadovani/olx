import 'package:flutter/material.dart';
import 'file:///C:/Users/valdecir.junior/AndroidStudioProjects/olx/lib/views/Home.dart';

  final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff9c27b0),
    accentColor: Color(0xff7b1fa2)
  );

void main() {
  runApp(MaterialApp(
    title: "OLX",
    home: Home(),
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
  ));
}
