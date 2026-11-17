import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome Back ${widget.username}'),
          ),
        );
      }
    });
  }

  // Open Phone, SMS or Email after checking canLaunchUrl.
  Future<void> openApp(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!opened && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open the application'),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the application'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No compatible application found'),
          ),
        );
      }
    }
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
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome Back ${widget.username}',
              style: const TextStyle(fontSize: 24),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
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
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
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
          ],
        ),
      ),
    );
  }
}
