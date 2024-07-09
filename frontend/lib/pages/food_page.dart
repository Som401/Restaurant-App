import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/models/cart_item.dart';
import 'package:frontend/models/food.dart';
import 'package:frontend/providers/user_provider.dart';

import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({
    super.key,
    required this.food,
  }) {
    for (Addon addon in food.availableAddons) {
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  void addToCart(Food food, Map<Addon, bool> selectedAddons) {
    List<AddonInfo> currentlySelectedAddons = [];
    for (Addon addon in widget.food.availableAddons) {
      if (selectedAddons[addon] == true) {
        currentlySelectedAddons
            .add(AddonInfo(name: addon.name, price: addon.price));
      }
    }
    context.read<UserProvider>().addToCart(
        FoodInfo(name: food.name, price: food.price, imagePath: food.imagePath, id: food.id),
        currentlySelectedAddons);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return Stack(
      children: [
        Scaffold(
            body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  Image.asset(
                    widget.food.imagePath,
                    height: minDimension * 0.8,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.food.name,
                            style: TextStyle(
                              fontSize: minDimension * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        Text(
                          '${widget.food.price} DT',
                          style: TextStyle(
                              fontSize: minDimension * 0.04,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(widget.food.description,
                            style: TextStyle(
                              fontSize: minDimension * 0.04,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.tertiary,
                          thickness: minDimension * 0.004,
                        ),
                        Text('Add-ons',
                            style: TextStyle(
                              fontSize: minDimension * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: minDimension * 0.004),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.food.availableAddons.length,
                            itemBuilder: (context, index) {
                              Addon addon = widget.food.availableAddons[index];
                              return CheckboxListTile(
                                  activeColor: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  title: Text(addon.name,
                                      style: TextStyle(
                                        fontSize: minDimension * 0.04,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                                  subtitle: Text('${addon.price} DT',
                                      style: TextStyle(
                                        fontSize: minDimension * 0.03,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )),
                                  value: widget.selectedAddons[addon],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      widget.selectedAddons[addon] = value!;
                                    });
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: height * 0.04,
                  right: width * 0.05,
                  left: width * 0.05),
              child: MyButton(
                text: "Add to cart",
                onTap: () => addToCart(widget.food, widget.selectedAddons),
              ),
            ),
          ],
        )),
        SafeArea(
            child: Opacity(
          opacity: 0.6,
          child: Container(
              margin: EdgeInsets.only(left: 25, top: Platform.isIOS ? 0 : 25),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle),
              child: Material(
                type: MaterialType.transparency,
                child: IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  icon: const Icon(Icons.arrow_back),
                  iconSize: minDimension * 0.06,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )),
        )),
      ],
    );
  }
}
