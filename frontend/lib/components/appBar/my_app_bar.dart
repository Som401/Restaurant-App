import 'dart:math';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  const MyAppBar({super.key, required this.scaffoldKey, required this.title});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return AppBar(
      title: Text(title,
          style: TextStyle(
            fontSize: minDimension * 0.05,
            color: Theme.of(context).colorScheme.primary,
          )),
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: minDimension * 0.1,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.primary,
          size: minDimension * 0.06,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      MediaQuery.of(scaffoldKey.currentContext!).size.height * 0.1);
}
