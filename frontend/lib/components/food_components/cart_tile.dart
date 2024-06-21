import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/quantity_selector/my_quantity_selector.dart';
import 'package:frontend/models/cart_item.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;
  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return Consumer<UserProvider>(
        builder: (context, user, child) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: minDimension * 0.02,
                        vertical: minDimension * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            cartItem.food.imagePath,
                            width: minDimension * 0.25,
                            height: minDimension * 0.25,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: minDimension * 0.03,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.food.name,
                                style: TextStyle(
                                    fontSize: minDimension * 0.04,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${cartItem.food.price + cartItem.selectedAddons.fold(0, (previousValue, addon) => previousValue + addon.price)}',
                                          style: TextStyle(
                                            fontSize: minDimension * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' DT',
                                          style: TextStyle(
                                            fontSize: minDimension * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  MyQuantitySlector(
                                      quantity: cartItem.quantity,
                                      onIncrement: () {
                                        user.addToCart(cartItem.food,
                                            cartItem.selectedAddons);
                                      },
                                      onDecrement: () {
                                        user.removeFromCart(cartItem);
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: cartItem.selectedAddons.isEmpty ? 0 : height * 0.1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.01,
                        bottom: height * 0.01,
                      ),
                      children: cartItem.selectedAddons
                          .map((addon) => Padding(
                                padding: EdgeInsets.only(
                                  right: width * 0.01,
                                ),
                                child: FilterChip(
                                  label: Row(
                                    children: [
                                      Text(addon.name,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: minDimension * 0.04,
                                          )),
                                      Text(' (${addon.price}) DT',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: minDimension * 0.04,
                                          )),
                                    ],
                                  ),
                                  onSelected: (value) {},
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                ),
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            ));
  }
}
