
import 'package:flutter/material.dart';
import 'main.dart';

/// This is the login page for Lab 2.
/// StatefulWidget because the image and language can change.
class Lab2Page extends StatefulWidget {
  const Lab2Page({super.key});

  /// Creates the state for the login page.
  @override
  State<Lab2Page> createState() => _Lab2PageState();
}

/// Controls the login page, image, and language.
class _Lab2PageState extends State<Lab2Page> {
  final TextEditingController loginController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  String imageSource = 'images/question-mark.png';
  bool isEnglish = true;

  /// Checks the password and changes the image.
  void checkPassword() {
    setState(() {
      if (passwordController.text == 'ASDF') {
        imageSource = 'images/idea.png';
      } else {
        imageSource = 'images/stop.png';
      }
    });
  }

  /// Changes between English and Portuguese.
  void changeLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  /// Releases the text controllers.
  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Builds the login screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8C2F5),
        title: const Text(
          'Flutter Demo Home Page',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: changeLanguage,
            child: Text(
              isEnglish ? 'PT' : 'EN',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF7FF),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: loginController,
                  decoration: InputDecoration(
                    labelText: isEnglish
                        ? 'Login'
                        : 'Usuário',
                    border: const OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: isEnglish
                        ? 'Password'
                        : 'Senha',
                    border: const OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: checkPassword,
                  child: Text(
                    isEnglish ? 'Login' : 'Entrar',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Image.asset(
                  imageSource,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
