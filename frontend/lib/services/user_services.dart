import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final auth.AuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final auth.UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final auth.User? user = userCredential.user;

        return user;
      } else {
        print('Error: user is null after signing in with credential');
      }
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      return null;
    }
    return null;
  }

  Future<User> registerUserWithGoogle(String email, String displayName) async {
    auth.User? user = _auth.currentUser;

    User newUser = User(
      name: displayName,
      phoneNumber: '',
      dialCode: '+216',
      isoCode: 'TN',
      providerId: user!.providerData.first.providerId,
    );
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson())
        .then((_) {
      print("User added to Firestore successfully");
      return newUser;
    }).catchError((error) {
      print("Failed to add user to Firestore: $error");
      throw Exception("Failed to add user to Firestore");
    });

    return newUser;
  }

  Future<void> registerUser(String email, String password, String fullName,
      String phoneNumber, String dialCode, String isoCode) async {
    auth.UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);

    User user = User(
      name: fullName,
      phoneNumber: phoneNumber,
      dialCode: dialCode,
      isoCode: isoCode,
      providerId: userCredential.user!.providerData.first.providerId,
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

  Future<void> updateUserDetails(
      String newName,
      String newEmail,
      String newPhoneNumber,
      String? password,
      String dialCode,
      String isoCode,
      String providerId,
      BuildContext context) async {
    try {
      auth.User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user signed in");
      }
      if (providerId == 'password' && password != null) {
        final credential = auth.EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password,
        );
        await currentUser.reauthenticateWithCredential(credential);
        print("Re-authentication successful");
      }

      if (currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
        print(
            "User email updated and verification email sent to $newEmail successfully");
      }

      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': newName,
        'phoneNumber': newPhoneNumber,
        'dialCode': dialCode,
        'isoCode': isoCode,
      });
      print("User details updated in Firestore successfully");
      User updatedUser = User(
        name: newName,
        phoneNumber: newPhoneNumber,
        dialCode: dialCode,
        isoCode: isoCode,
        providerId: providerId,
      );

      // Assuming you have access to the UserProvider instance, e.g., via Provider.of<UserProvider>(context, listen: false)
      Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);
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
