import 'dart:math';

import 'package:flutter/material.dart';

class FoodCategoryIcon extends StatefulWidget {
  final String imagePath;
  final String categoryName;
  final bool isSelected;
  const FoodCategoryIcon(
      {super.key,
      required this.imagePath,
      required this.categoryName,
      this.isSelected = false});

  @override
  State<FoodCategoryIcon> createState() => _FoodCategoryIconState();
}

class _FoodCategoryIconState extends State<FoodCategoryIcon> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    if (widget.isSelected) {
      print(widget.categoryName);
      print(widget.isSelected);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(minDimension * 0.02),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .tertiary
                .withOpacity(widget.isSelected ? 1.0 : 0.5),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            widget.imagePath,
            width: minDimension * 0.09,
          ),
        ),
        SizedBox(height: minDimension * 0.01),
        Text(
          widget.categoryName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: minDimension * 0.05,
          ),
        ),
      ],
    );
  }
}
