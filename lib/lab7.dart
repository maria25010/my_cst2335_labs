
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Lab7Page extends StatefulWidget {
  const Lab7Page({super.key});

  @override
  State<Lab7Page> createState() => _Lab7PageState();
}

class _Lab7PageState extends State<Lab7Page> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  List<Map<String, dynamic>> contacts = [];

  Database? database;
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    openDatabaseFile();
  }

  // Open the database and create the table.
  Future<void> openDatabaseFile() async {
    database = await openDatabase(
      'contacts_lab7.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            phone TEXT,
            email TEXT
          )
        ''');
      },
    );

    await loadContacts();
  }

  // Load saved contacts.
  Future<void> loadContacts() async {
    if (database == null) return;

    final result = await database!.rawQuery(
      'SELECT * FROM contacts',
    );

    if (mounted) {
      setState(() {
        contacts = result;
      });
    }
  }

  // Add a contact to the database.
  Future<void> addContact() async {
    if (database == null) return;

    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      return;
    }

    await database!.rawInsert(
      'INSERT INTO contacts (firstName, lastName, phone, email) '
          'VALUES (?, ?, ?, ?)',
      [
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),
      ],
    );

    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();

    await loadContacts();
  }

  // Delete a contact from the database.
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
            onPressed: () async {
              Navigator.pop(dialogContext);

              if (database == null) return;

              await database!.rawDelete(
                'DELETE FROM contacts WHERE id = ?',
                [contacts[index]['id']],
              );

              await loadContacts();
            },
            child: Text(isEnglish ? 'Yes' : 'Sim'),
          ),
        ],
      ),
    );
  }

  // Change language.
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
    database?.close();
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
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: isEnglish
                    ? 'Phone Number'
                    : 'Número de Telefone',
              ),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: isEnglish ? 'Email' : 'E-mail',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addContact,
              child: Text(isEnglish ? 'Add' : 'Adicionar'),
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
