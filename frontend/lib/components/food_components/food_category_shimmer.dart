import 'dart:math';

import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class FoodCategoryShimmer extends StatelessWidget {
  const FoodCategoryShimmer({super.key});

  double calculateTextHeight(BuildContext context, double minDimension) {
    final textStyle = TextStyle(
      fontSize: minDimension * 0.05,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: "order tile text", style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height = textPainter.size.height;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final totalHeight = calculateTextHeight(context, minDimension);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => SizedBox(
        height: minDimension * 0.25, // Adjust height if necessary
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8, // Generate 8 items
          itemBuilder: (context, index) => Container(
            width: minDimension * 0.2, // Adjust width for each item
            padding: EdgeInsets.symmetric(horizontal: minDimension * 0.01),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
                  highlightColor: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  child: Container(
                    width: minDimension * 0.11,
                    height: minDimension * 0.11,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeProvider.isDarkMode ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: minDimension * 0.02), // Space between circle and rectangle
                Shimmer.fromColors(
                  baseColor: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
                  highlightColor: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  child: Container(
                    width: minDimension * 0.18, // Adjust width to match design
                    height: totalHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: themeProvider.isDarkMode ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}