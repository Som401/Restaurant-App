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

  Future<void> updateUserDetails(String newName, String newEmail,
      String newPhoneNumber, String password) async {
    try {
      auth.User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user signed in");
      }
      final credential = auth.EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );

      await currentUser.reauthenticateWithCredential(credential);
      print("Re-authentication successful");

      if (currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
        print("User email updated in Firebase Authentication successfully");
      }

      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': newName,
        'phoneNumber': newPhoneNumber,
      });
      print("User details updated in Firestore successfully");

      if (currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
        print("Verification email sent to $newEmail");
      }
    } catch (error) {
      print("Failed to re-authenticate and update user details: $error");
      throw Exception("Failed to re-authenticate and update user details");
    }
  }

  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    try {
      auth.User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user signed in");
      }
      final credential = auth.EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);
      print("Re-authentication successful");

      await currentUser.updatePassword(newPassword);
      print("User password updated successfully");
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print("Wrong password provided for user.");
        throw Exception("Wrong password provided.");
      } else {
        print("Failed to update user password: $e");
        throw Exception("Failed to update user password");
      }
    } catch (error) {
      print("Failed to update user password: $error");
      throw Exception("Failed to update user password");
    }
  }

  Future<void> resetUserPassword(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception("Email address is required");
      }
      if (!email.contains('@') || !email.contains('.')) {
        throw Exception("Invalid email address");
      }
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent successfully to $email");
    } catch (error) {
      print("Failed to send password reset email: $error");
      throw Exception("Failed to send password reset email");
    }
  }
}
