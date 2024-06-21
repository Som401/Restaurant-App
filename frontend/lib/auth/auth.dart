import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<auth.User?>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userUid = snapshot.data!.uid;
            return ChangeNotifierProvider<UserProvider>(
              create: (_) => UserProvider(),
              child: FutureBuilder<User?>(
                future: _userService.fetchUserDetails(userUid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<UserProvider>(context, listen: false)
                          .setUser(userSnapshot.data!);
                    });
                    return const HomePage();
                  } else {
                    return const Text("User data not found.");
                  }
                },
              ),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
