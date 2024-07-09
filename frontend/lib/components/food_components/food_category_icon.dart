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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(minDimension * 0.02),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            widget.imagePath,
            width: minDimension * 0.11,
            height: minDimension * 0.11,
          ),
        ),
        SizedBox(height: minDimension * 0.01),
        Text(
          widget.categoryName,
          style: TextStyle(
            color: widget.isSelected
                ? Theme.of(context).colorScheme.inverseSurface
                : Theme.of(context).colorScheme.secondary,
            fontSize: minDimension * 0.05,
            fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
