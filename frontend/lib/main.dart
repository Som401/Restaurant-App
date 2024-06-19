import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/splash_screen_page.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAgHSwid3ANv9ENqC8tuCLEio0idSytZQY",
              authDomain: "restaurantapp-6e948.firebaseapp.com",
              projectId: "restaurantapp-6e948",
              storageBucket: "restaurantapp-6e948.appspot.com",
              messagingSenderId: "300892209906",
              appId: "1:300892209906:web:5e3af02bdefdded2c1c66b",
              measurementId: "G-GTX6KEDEWV"));
    } else {
      await Firebase.initializeApp();
    }
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => Restaurant()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage(),
    );
  }
}
