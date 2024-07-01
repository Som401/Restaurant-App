import 'dart:math';

import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerItem extends StatelessWidget {
  const ShimmerItem({super.key});

  double calculateTextsHeight(
      BuildContext context, double minDimension, double height) {
    final textStyle = TextStyle(
      fontSize: minDimension * 0.05,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: "order tile text", style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height1 = textPainter.size.height;

    final totalHeight = height1 * 4 + (height * 0.06);
    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final totalHeight = calculateTextsHeight(context, minDimension, height);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => (Container(
        height: totalHeight,
        width: width,
        margin: EdgeInsets.symmetric(vertical: height * 0.02),
        child: Shimmer.fromColors(
          baseColor: themeProvider.isDarkMode
              ? Colors.grey.shade900
              : Colors.grey.shade300,
          highlightColor: themeProvider.isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          child: Container(
            width: totalHeight,
            height: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: themeProvider.isDarkMode ? Colors.grey : Colors.white,
            ),
          ),
        ),
      )),
    );
    // return Container(
    //   height: 100,
    //   padding: const EdgeInsets.symmetric(vertical: 8),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       SizedBox(
    //         width: 120.0,
    //         height: 100.0,
    //         child: Shimmer.fromColors(
    //           baseColor: Colors.grey.shade300,
    //           highlightColor: Colors.grey.shade200,
    //           child: Container(
    //             width: 60,
    //             height: 60,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12.0),
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 12,
    //       ),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Shimmer.fromColors(
    //               baseColor: Colors.grey.shade300,
    //               highlightColor: Colors.grey.shade200,
    //               child: Container(
    //                 height: 20,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(12.0),
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             // Shimmer for Description
    //             Shimmer.fromColors(
    //               baseColor: Colors.grey.shade300,
    //               highlightColor: Colors.grey.shade200,
    //               child: Container(
    //                 height: 20,
    //                 width: 100,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(12.0),
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             // Shimmer for Another Description
    //             Shimmer.fromColors(
    //               baseColor: Colors.grey.shade300,
    //               highlightColor: Colors.grey.shade200,
    //               child: Container(
    //                 height: 20,
    //                 width: 50,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(12.0),
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
