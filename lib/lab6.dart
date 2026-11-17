
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Lab6Page extends StatefulWidget {
  const Lab6Page({super.key});

  @override
  State<Lab6Page> createState() => _Lab6PageState();
}

class _Lab6PageState extends State<Lab6Page> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final List<Map<String, String>> contacts = [];

  bool isEnglish = true;

  // Add a new contact.
  void addContact() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      contacts.add({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
      });
    });

    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
  }

  // Open Phone, SMS or Email.
  Future<void> openApp(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!opened && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEnglish
                    ? 'Could not open the application'
                    : 'Não foi possível abrir o aplicativo',
              ),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish
                  ? 'Could not open the application'
                  : 'Não foi possível abrir o aplicativo',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish
                  ? 'No compatible application found'
                  : 'Nenhum aplicativo compatível encontrado',
            ),
          ),
        );
      }
    }
  }

  // Ask before deleting a contact.
  void deleteContact(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          isEnglish ? 'Delete Contact?' : 'Excluir contato?',
        ),
        content: Text(
          isEnglish
              ? 'Are you sure you want to delete this contact?'
              : 'Tem certeza de que deseja excluir este contato?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(isEnglish ? 'No' : 'Não'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                contacts.removeAt(index);
              });
              Navigator.pop(dialogContext);
            },
            child: Text(isEnglish ? 'Yes' : 'Sim'),
          ),
        ],
      ),
    );
  }

  // Change the language.
  void changeLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8C2F5),
        title: Text(
          isEnglish ? 'Contact List' : 'Lista de Contatos',
        ),
        actions: [
          TextButton(
            onPressed: changeLanguage,
            child: Text(
              isEnglish ? 'PT' : 'EN',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: isEnglish ? 'First Name' : 'Nome',
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: isEnglish ? 'Last Name' : 'Sobrenome',
              ),
            ),

            // Phone field and buttons.
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: isEnglish
                          ? 'Phone Number'
                          : 'Número de Telefone',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (phoneController.text.trim().isNotEmpty) {
                      openApp(
                        Uri(
                          scheme: 'tel',
                          path: phoneController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.phone),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (phoneController.text.trim().isNotEmpty) {
                      openApp(
                        Uri(
                          scheme: 'sms',
                          path: phoneController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.sms),
                ),
              ],
            ),

            // Email field and button.
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: isEnglish ? 'Email' : 'E-mail',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.trim().isNotEmpty) {
                      openApp(
                        Uri(
                          scheme: 'mailto',
                          path: emailController.text.trim(),
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.email),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: addContact,
              child: Text(isEnglish ? 'Enter' : 'Adicionar'),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: contacts.isEmpty
                  ? Center(
                child: Text(
                  isEnglish
                      ? 'There are no contacts in the list'
                      : 'Não há contatos na lista',
                ),
              )
                  : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        '${contact['firstName']} '
                            '${contact['lastName']}',
                      ),
                      subtitle: Text(
                        '${contact['phone']}\n'
                            '${contact['email']}',
                      ),
                      isThreeLine: true,
                      onLongPress: () => deleteContact(index),
                      onTap: () {
                        setState(() {
                          firstNameController.text =
                              contact['firstName'] ?? '';
                          lastNameController.text =
                              contact['lastName'] ?? '';
                          phoneController.text =
                              contact['phone'] ?? '';
                          emailController.text =
                              contact['email'] ?? '';
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
