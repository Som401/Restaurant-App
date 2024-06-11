import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, User? user});
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user?.name}  👋',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: minDimension * 0.05),
        ),
        centerTitle: false,
      ),
      drawer: const MyDrawer(),
    );
  }
}
