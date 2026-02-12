
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(OncoSoulApp());
}

class OncoSoulApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OncoSoul',
      home: SplashScreen(),
    );
  }
}
