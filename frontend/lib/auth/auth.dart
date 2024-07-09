import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:frontend/pages/menu_page.dart';
import 'package:frontend/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<auth.User?>(
      stream: auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var userUid = snapshot.data!.uid;
          print(userUid);
          return MenuPage(userUid: userUid);
        } else {
          return const LoginPage();
        }
      },
    ));
  }
}