import 'dart:math';

import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  
  final String text;
  final IconData? icon;
  
  final void Function()? onTap;

  const MyDrawerTile({super.key, required this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return Padding(
        padding: EdgeInsets.only(left: width * 0.02, bottom: height * 0.02),
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: minDimension * 0.05),
          ),
          leading: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: minDimension * 0.05,
          ),
          onTap: onTap,
        ));
  }
}
