import 'dart:math';

import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class FoodShimmerTile extends StatelessWidget {
  const FoodShimmerTile({super.key});

  List<double> calculateTextHeight(BuildContext context, double minDimension) {
    final textStyle1 = TextStyle(
      fontSize: minDimension * 0.05,
    );
    final textPainter1 = TextPainter(
      text: TextSpan(text: "food tile text", style: textStyle1),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height1 = textPainter1.size.height;
    final textStyle2 = TextStyle(
      fontSize: minDimension * 0.05,
    );
    final textPainter2 = TextPainter(
      text: TextSpan(text: "food tile text", style: textStyle2),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height2 = textPainter2.size.height;

    return [height1, height2];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final heights = calculateTextHeight(context, minDimension);
    final height1 = heights[0];
    final height2 = heights[1];

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (SizedBox(
                    height: minDimension * 0.25,
                    width: minDimension * 0.25,
                    child: Shimmer.fromColors(
                      baseColor: themeProvider.isDarkMode
                          ? Colors.grey.shade900
                          : Colors.grey.shade300,
                      highlightColor: themeProvider.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      child: Container(
                        height: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: themeProvider.isDarkMode
                              ? Colors.grey
                              : Colors.white,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: minDimension * 0.03,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: themeProvider.isDarkMode
                              ? Colors.grey.shade900
                              : Colors.grey.shade300,
                          highlightColor: themeProvider.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          child: Container(
                            height: height1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: themeProvider.isDarkMode
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Shimmer.fromColors(
                          baseColor: themeProvider.isDarkMode
                              ? Colors.grey.shade900
                              : Colors.grey.shade300,
                          highlightColor: themeProvider.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          child: Container(
                            height: height2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: themeProvider.isDarkMode
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Divider(
              color: Theme.of(context).colorScheme.tertiary,
              thickness: 3,
            ),
          )
        ],
      ),
    );
  }
}
