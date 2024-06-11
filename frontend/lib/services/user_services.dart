import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(String email, String password, String fullName,
      String phoneNumber) async {
    auth.UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    User user = User(
      name: fullName,
      email: email,
      phoneNumber: phoneNumber,
    );

    await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(user.toJson())
        .then((_) {
      print("User added to Firestore successfully");
    }).catchError((error) {
      print("Failed to add user to Firestore: $error");
      throw Exception("Failed to add user to Firestore");
    });
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    print("Login started");

    await _auth.signInWithEmailAndPassword(email: email, password: password);
    print("Sign in successful, fetching user details");
  }

  Future<void> signOut(BuildContext context) async {
  await auth.FirebaseAuth.instance.signOut();
  Provider.of<UserProvider>(context, listen: false).clearUser();
}

  Future<User> fetchUserDetails(String uid) async {
    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return User.fromMap(userDoc.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }
}
