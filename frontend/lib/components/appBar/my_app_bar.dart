import 'dart:math';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final bool isFromDrawerMenu;
  const MyAppBar(
      {super.key,
      required this.scaffoldKey,
      required this.title,
      this.isFromDrawerMenu = true});

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
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        leading: isFromDrawerMenu
            ? IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.primary,
                  size: minDimension * 0.06,
                ),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              )
            : IconButton(
                icon: Icon(Icons.arrow_back, size: minDimension * 0.08),
                onPressed: () => Navigator.of(context).pop(),
              ));
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(
        MediaQuery.of(scaffoldKey.currentContext!).size.height * 0.07);
  }
}
