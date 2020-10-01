import 'package:flutter/material.dart';
import 'package:ml_flowerdetector_flutter/splash_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: "/splash",
      debugShowCheckedModeBanner: false,
      routes:{
        "/": (context) => HomePage(),
        "/splash" : (context) => MySplash(),
      }
    )
  );
}


