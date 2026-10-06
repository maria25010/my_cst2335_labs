
import 'package:flutter/material.dart';
import 'lab2.dart';
import 'lab3.dart';

/// Starts the Flutter application.
void main() {
  runApp(const MyApp());
}

/// Main application class.
/// StatelessWidget because its data does not change.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Builds the application and opens the student page.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Lab3Page(),    );
  }
}

/// Shows my student information.
/// StatelessWidget because the information stays the same.
class _MyStudentInfo extends StatelessWidget {
  const _MyStudentInfo();

  /// Builds the screen with three centered text widgets.
  @override
  Widget build(BuildContext context) {
    double myFontSize = 30.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8C2F5),
        title: const Text(
          'Flutter Demo Home Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFFFF7FF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My name is: Maria Eduarda Mann Pego - 041271052',
                style: TextStyle(fontSize: myFontSize),
                textAlign: TextAlign.center,
              ),
              Text(
                'The course is CST2335',
                style: TextStyle(fontSize: myFontSize),
                textAlign: TextAlign.center,
              ),
              Text(
                'Lab Assignment 1',
                style: TextStyle(fontSize: myFontSize),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
