
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Lab8Page extends StatefulWidget {
  const Lab8Page({super.key});

  @override
  State<Lab8Page> createState() => _Lab8PageState();
}

class _Lab8PageState extends State<Lab8Page> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  Database? database;

  List<Map<String, dynamic>> contacts = [];
  Map<String, dynamic>? selectedContact;

  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    openDatabaseFile();
  }

  // Open the same database used in Lab 7.
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

  // Load all contacts from the database.
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

  // Add a new contact.
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

  // Delete the selected contact.
  Future<void> deleteContact() async {
    if (database == null || selectedContact == null) return;

    final id = selectedContact!['id'];

    await database!.rawDelete(
      'DELETE FROM contacts WHERE id = ?',
      [id],
    );

    setState(() {
      selectedContact = null;
    });

    await loadContacts();
  }

  // Close the details page.
  void closeDetails() {
    setState(() {
      selectedContact = null;
    });
  }

  // Change language.
  void changeLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  // Contact list.
  Widget buildContactList() {
    return Column(
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
                  onTap: () {
                    setState(() {
                      selectedContact = contact;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Details page.
  Widget buildDetails() {
    if (selectedContact == null) {
      return Center(
        child: Text(
          isEnglish
              ? 'Select a contact to see details'
              : 'Selecione um contato para ver os detalhes',
        ),
      );
    }

    final contact = selectedContact!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish ? 'Contact Details' : 'Detalhes do Contato',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ID: ${contact['id']}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '${isEnglish ? 'Name' : 'Nome'}: '
                '${contact['firstName']} ${contact['lastName']}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '${isEnglish ? 'Phone' : 'Telefone'}: '
                '${contact['phone']}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${contact['email']}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: deleteContact,
                child: Text(
                  isEnglish ? 'Delete' : 'Excluir',
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: closeDetails,
                child: Text(
                  isEnglish ? 'Close' : 'Fechar',
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >= 600 &&
                  MediaQuery.of(context).orientation ==
                      Orientation.landscape;

          if (isWide) {
            // Desktop / tablet landscape:
            // list on the left, details on the right.
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: buildContactList(),
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: buildDetails(),
                ),
              ],
            );
          }

          // Phone / portrait:
          // details replace the list.
          return selectedContact == null
              ? Padding(
            padding: const EdgeInsets.all(16),
            child: buildContactList(),
          )
              : buildDetails();
        },
      ),
    );
  }
}
