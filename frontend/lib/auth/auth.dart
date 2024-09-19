import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:frontend/pages/menu_page.dart';
import 'package:frontend/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    print('Building AuthPage...'); // 1. Before StreamBuilder
    return StreamBuilder<auth.User?>(
      stream: auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('StreamBuilder called'); // 3. Inside builder function
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Waiting for connection...'); // Checking connection state
        }
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}'); // Logging any errors
        }
        if (snapshot.hasData) {
          var userUid = snapshot.data!.uid;
          var email = snapshot.data!.email!;
          var displayName = snapshot.data!.displayName ?? '';
          return MenuPage(
              userUid: userUid, email: email, displayName: displayName);
        } else {
          print('No user logged in.'); // 5. Inside else branch
          return const LoginPage();
        }
      },
    );
  }
}
