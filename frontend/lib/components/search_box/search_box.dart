import 'dart:math';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final dynamicHeight =
        height * 0.02 * 2 + minDimension * 0.06 + height * 0.01;
    return Container(
      padding: EdgeInsets.only(bottom: height * 0.01),
      height: dynamicHeight,
      child: TextField(
        style: TextStyle(
          fontSize: minDimension * 0.05,
        ),
        decoration: InputDecoration(
          hintText: "Search food",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: minDimension * 0.04,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: minDimension * 0.06,
            color: Theme.of(context).colorScheme.secondary,
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.02),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
