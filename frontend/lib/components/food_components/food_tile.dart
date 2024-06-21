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
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(food.imagePath,
                        height: minDimension * 0.25,
                        width: minDimension * 0.25,
                        fit: BoxFit.fill),
                  ),
                  SizedBox(
                    width: minDimension * 0.03,
                  ),
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
                          '${food.price} DT',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: minDimension * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    );
  }
}


// Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.asset(
//                             cartItem.food.imagePath,
//                             width: minDimension * 0.25,
//                             height: minDimension * 0.25,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         SizedBox(
//                           width: minDimension * 0.03,
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.star,
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .inverseSurface,
//                                     size: minDimension * 0.04,
//                                   ),
//                                   SizedBox(
//                                     width: minDimension * 0.02,
//                                   ),
//                                   Text(
//                                     '4.5',
//                                     style: TextStyle(
//                                         fontSize: minDimension * 0.04,
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .inverseSurface),
//                                   )
//                                 ],
//                               ),
//                               Text(
//                                 cartItem.food.name,
//                                 style: TextStyle(
//                                     fontSize: minDimension * 0.04,
//                                     color:
//                                         Theme.of(context).colorScheme.primary),
//                               ),
//                               SizedBox(
//                                 height: height * 0.01,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text:
//                                               '${cartItem.food.price + cartItem.selectedAddons.fold(0, (previousValue, addon) => previousValue + addon.price)}',
//                                           style: TextStyle(
//                                             fontSize: minDimension * 0.04,
//                                             fontWeight: FontWeight.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text: ' DT',
//                                           style: TextStyle(
//                                             fontSize: minDimension * 0.04,
//                                             fontWeight: FontWeight.bold,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .inverseSurface,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),                            
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),