
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Lab2Page extends StatefulWidget {
  const Lab2Page({super.key});

  @override
  State<Lab2Page> createState() => _Lab2PageState();
}

class _Lab2PageState extends State<Lab2Page> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String imageSource = 'images/question-mark.png';
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    loadLogin();
  }

  // Load saved username and password.
  Future<void> loadLogin() async {
    final username = await storage.read(key: 'username');
    final password = await storage.read(key: 'password');

    if (!mounted) return;

    if (username != null && password != null) {
      setState(() {
        loginController.text = username;
        passwordController.text = password;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish
                  ? 'Previous login information loaded'
                  : 'Dados de login anteriores carregados',
            ),
          ),
        );
      });
    }
  }

  // Save or delete login information.
  Future<void> saveLogin(bool save) async {
    if (save) {
      await storage.write(
        key: 'username',
        value: loginController.text,
      );
      await storage.write(
        key: 'password',
        value: passwordController.text,
      );
    } else {
      await storage.delete(key: 'username');
      await storage.delete(key: 'password');
    }
  }

  // Check password and show the dialog.
  void checkPassword() {
    setState(() {
      if (passwordController.text == 'ASDF') {
        imageSource = 'images/idea.png';
      } else {
        imageSource = 'images/stop.png';
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEnglish ? 'Save Login?' : 'Salvar login?'),
        content: Text(
          isEnglish
              ? 'Would you like to save your username and password?'
              : 'Você gostaria de salvar seu usuário e senha?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await saveLogin(false);
            },
            child: Text(isEnglish ? 'No' : 'Não'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await saveLogin(true);
            },
            child: Text(isEnglish ? 'Yes' : 'Sim'),
          ),
        ],
      ),
    );
  }

  // Change between English and Portuguese.
  void changeLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8C2F5),
        title: Text(
          isEnglish
              ? 'Flutter Demo Home Page'
              : 'Página inicial do Flutter',
          style: const TextStyle(color: Colors.black),
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
                    labelText: isEnglish ? 'Login' : 'Usuário',
                    border: const OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: isEnglish ? 'Password' : 'Senha',
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
