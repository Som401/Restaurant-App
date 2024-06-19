import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/food.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTile({super.key, required this.food, this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return Container(
      decoration: BoxDecoration(
        //color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: minDimension * 0.05,
                            )),
                        Text(
                          '\$${food.price}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: minDimension * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(food.imagePath,
                        height: minDimension * 0.25,
                        width: minDimension * 0.25,
                        fit: BoxFit.fill),
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
