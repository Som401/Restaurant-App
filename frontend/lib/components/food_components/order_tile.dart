import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/components/food_components/my_receipt.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderTile({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final Timestamp timestamp = order['timestamp'] as Timestamp;

    return Padding(
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
                    DottedBorder(
                      borderType: BorderType.RRect,
                      dashPattern: [
                        4 * (minDimension / 500),
                        4 * (minDimension / 500)
                      ],
                      radius: Radius.circular(8 * (minDimension / 500)),
                      padding: EdgeInsets.all(7 * (minDimension / 500)),
                      color: order['state'] == 'accepted' ||
                              order['state'] == 'complete'
                          ? Colors.green
                          : (order['state'] == 'denied'
                              ? Colors.red
                              : Colors.orange),
                      child: Icon(
                        size: minDimension * 0.05,
                        order['state'] == 'accepted' ||
                                order['state'] == 'complete'
                            ? Icons.check_circle
                            : (order['state'] == 'denied'
                                ? Icons.error
                                : Icons.access_time),
                        color: order['state'] == 'accepted' ||
                                order['state'] == 'complete'
                            ? Colors.green
                            : (order['state'] == 'denied'
                                ? Colors.red
                                : Colors.orange),
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Number: #105',
                            // 'Order Number: #${order['orderNumber']}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: minDimension * 0.05,
                            )),
                        Text(
                          'Order on: ${DateFormat('yyyy-MM-dd - HH:mm').format(timestamp.toDate())}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.05,
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
                        'Price (${calculateTotalItems(order['items'])} item${calculateTotalItems(order['items']) > 1 ? 's' : ''})',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: minDimension * 0.05,
                        )),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: calculateTotalCost(order['items'])
                                .toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: minDimension * 0.05,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' DT',
                            style: TextStyle(
                              fontSize: minDimension * 0.05,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
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
                          fontSize: minDimension * 0.05,
                        )),
                    Text(order['state'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.05,
                        )),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: MyReceipt(
                          order: order,
                        ),
                        // content: Text(displaycartReceipt(order,
                        //     minDimension)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close',
                                style: TextStyle(
                                  fontSize: minDimension * 0.05,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                )),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Theme.of(context).colorScheme.inverseSurface,
                  size: minDimension * 0.05,
                ),
              ),
            ),
          ]),
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
    totalCost += item['price'];
  }
  return totalCost;
}

String displaycartReceipt(Map<String, dynamic> order, double minDimension) {
  final receipt = StringBuffer();
  receipt.writeln("Here's your receipt.");
  receipt.writeln();
  final DateTime dateTime = order['timestamp'].toDate();

  String formattedDate = DateFormat('yyyy-MM-dd - HH:mm').format(dateTime);

  receipt.writeln(formattedDate);
  receipt.writeln();
  receipt.writeln("- - - - - - - - - - - - - - - - - - - -");

  List<dynamic> cartItems = order['items'];

  for (final cartItem in cartItems) {
    receipt.writeln(
        "${cartItem['quantity']} x ${cartItem['food']} - \$ ${cartItem['price']}");

    if (cartItem['selectedAddons'].isNotEmpty) {
      String addons = cartItem['selectedAddons'].join(', ');
      receipt.writeln("Add-ons: $addons");
    }
    receipt.writeln();
  }
  receipt.writeln("- - - - - - - - - - - - - - - - - - - -");
  receipt.writeln();

  int totalItems = calculateTotalItems(cartItems);
  double totalPrice = calculateTotalCost(cartItems);
  receipt.writeln("Total Items: $totalItems");
  receipt.writeln("Total Price: \$ $totalPrice");

  return receipt.toString();
}
