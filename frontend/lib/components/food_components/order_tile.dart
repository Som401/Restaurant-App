
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
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
    print('order tile build ${timestamp}');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(minDimension * 0.01),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: minDimension * 0.01),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: const [4, 4],
                        radius: const Radius.circular(8),
                        padding: const EdgeInsets.all(7),
                        color: order['state'] == 'accepted' ||
                                order['state'] == 'complete'
                            ? Colors.green
                            : (order['state'] == 'denied'
                                ? Colors.red
                                : Colors.orange),
                        child: Icon(
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
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('',
                            // 'Order Number: #${order['orderNumber']}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: minDimension * 0.05,
                            )),
                        Text(
                          'Order on: ${DateFormat('yyyy-MM-dd - HH:mm:ss').format(timestamp.toDate())}',
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
                    Text('\$ ${calculateTotalCost(order['items'])}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.05,
                        )),
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
                        title: const Text('Receipt'),
                        titleTextStyle: TextStyle(
                          fontSize: minDimension * 0.05,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        content: Text(displaycartReceipt(order)),
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
    totalCost += item['totalPrice'];
  }
  return totalCost;
}

String displaycartReceipt(Map<String, dynamic> order) {
  final receipt = StringBuffer();
  receipt.writeln("Here's your receipt.");
  receipt.writeln();
  final Timestamp timestamp = order['timestamp'] as Timestamp;

  String formattedDate =
      DateFormat('yyyy-MM-dd - HH:mm:ss').format(order['timestamp']);
  print('order tile function  ${timestamp}');
  print('order tile function  ${formattedDate}');

  receipt.writeln(formattedDate);
  receipt.writeln();
  receipt.writeln("- - - - - - - - - - - - - - - - - - - -");

  List<dynamic> cartItems = order['items'];

  for (final cartItem in cartItems) {
    receipt.writeln(
        "${cartItem['quantity']} x ${cartItem['food']['name']} - \$ ${cartItem['totalPrice']}");
    if (cartItem['selectedAddons'].isNotEmpty) {
      String addons =
          cartItem['selectedAddons'].map((addon) => addon['name']).join(', ');
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
