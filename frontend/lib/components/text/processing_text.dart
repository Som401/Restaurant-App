import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ProcessingText extends StatefulWidget {
  const ProcessingText({super.key});

  @override
  State<ProcessingText> createState() => _ProcessingTextState();
}

class _ProcessingTextState extends State<ProcessingText> {
  int activeDotIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      setState(() {
        activeDotIndex = (activeDotIndex + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Processing',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: minDimension * 0.05,
                color: Colors.white)),
        ...List.generate(3, (index) => buildDot(index, minDimension, context)),
      ],
    );
  }

  Widget buildDot(int index, double minDimension, BuildContext context) {
    Color color = index <= activeDotIndex
        ? Colors.white
        : Theme.of(context).colorScheme.inverseSurface;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minDimension * 0.01),
      child: Text(
        '.',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: minDimension * 0.05,
          color: color,
        ),
      ),
    );
  }
}
