import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return  Scaffold(
                  appBar: AppBar(
                    title: const Text('Home'),
                    actions: [
                      IconButton(
                        icon:  const Icon(Icons.exit_to_app),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      )
                    ],
                  ),
                );
              } else {
                return const LoginPage();
              }
            }));
  }
}
