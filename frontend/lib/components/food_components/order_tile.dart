import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/components/food_components/my_receipt.dart';
import 'package:frontend/models/food.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';

class OrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderTile({super.key, required this.order});

  double calculateTextsHeight(
      BuildContext context, double minDimension, double height) {
    final textStyle = TextStyle(
      fontSize: minDimension * 0.04,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: "order tile text", style: textStyle),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height1 = textPainter.size.height;

    return height1 * 2;
  }

  List<Map<String, dynamic>> generateFoodItems(
      Restaurant menu, List<dynamic> items) {
    List<Map<String, dynamic>> foodItems = [];
    for (var item in items) {
      final Food food = menu.getFoodById(item['foodId']);
      List<Map<String, dynamic>> selectedAddonsList = [];

      double addonsTotalPrice = 0;

      for (int i = 0; i < food.availableAddons.length; i++) {
        if (item['selectedAddons'][i]) {
          Map<String, dynamic> addon = food.availableAddons[i].toJson();
          selectedAddonsList.add(addon);
          addonsTotalPrice += addon['price'];
        }
      }

      final foodItem = {
        'food': food.name,
        'price': food.price + addonsTotalPrice,
        'quantity': item['quantity'],
        'selectedAddons': selectedAddonsList,
      };
      foodItems.add(foodItem);
    }
    return foodItems;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final menu = Provider.of<Restaurant>(context, listen: false);
    final foodItems = generateFoodItems(menu, order['items']);
    final Timestamp timestamp = order['timestamp'] as Timestamp;
    double calculatedHeight =
        calculateTextsHeight(context, minDimension, height);
    final restaurantDetails = Provider.of<Restaurant>(context, listen: false);
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: MyReceipt(
                order: order,
                foodItems: foodItems,
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.02),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: minDimension * 0.01),
                        width: calculatedHeight,
                        height: calculatedHeight,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: [
                            4 * (minDimension / 500),
                            4 * (minDimension / 500)
                          ],
                          radius: Radius.circular(8 * (minDimension / 500)),
                          padding: EdgeInsets.all(7 * (minDimension / 500)),
                          strokeWidth: 2 * (minDimension / 500),
                          color: order['state'] == 'accepted' ||
                                  order['state'] == 'complete'
                              ? Colors.green
                              : (order['state'] == 'denied'
                                  ? Colors.red
                                  : Colors.orange),
                          child: Center(
                            child: Icon(
                              order['state'] == 'accepted' ||
                                      order['state'] == 'complete'
                                  ? Icons.check_circle
                                  : (order['state'] == 'denied'
                                      ? Icons.error
                                      : Icons.access_time),
                              size: minDimension * 0.07,
                              color: order['state'] == 'accepted' ||
                                      order['state'] == 'complete'
                                  ? Colors.green
                                  : (order['state'] == 'denied'
                                      ? Colors.red
                                      : Colors.orange),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Number: ${order['orderNumber']}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: minDimension * 0.04,
                              )),
                          Text(
                            'Order on: ${DateFormat('yyyy-MM-dd - HH:mm').format(timestamp.toDate())}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: minDimension * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Price (${calculateTotalItems(foodItems)} item${calculateTotalItems(foodItems) > 1 ? 's' : ''})',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: minDimension * 0.04,
                          )),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${(calculateTotalCost(foodItems) + (order['isDelivery'] == true ? restaurantDetails.deliveryFee : 0)).toStringAsFixed(2)} DT",
                              style: TextStyle(
                                fontSize: minDimension * 0.04,
                                color: Theme.of(context).colorScheme.primary,
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
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("State:",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: minDimension * 0.04,
                          )),
                      Text(order['state'],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.04,
                          )),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Theme.of(context).colorScheme.inverseSurface,
                  size: minDimension * 0.04,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

int calculateTotalItems(List<dynamic> items) {
  int totalItems = 0;
  for (var item in items) {
    int quantity = item['quantity'];
    totalItems += quantity;
  }
  return totalItems;
}

double calculateTotalCost(List<dynamic> items) {
  double totalCost = 0;
  for (var item in items) {
    totalCost += item['price'] * item['quantity'];
  }
  return totalCost;
}
