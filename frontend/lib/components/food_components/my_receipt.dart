import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReceipt extends StatelessWidget {
  final Map<String, dynamic> order;

  const MyReceipt({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    final DateTime dateTime = order['timestamp'].toDate();
    String formattedDate = DateFormat('yyyy-MM-dd - HH:mm').format(dateTime);
    List<dynamic> cartItems = order['items'];

    return SizedBox(
      height: height * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "DelCapo",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.05,
                  ),
                ),
                // Text(
                //   "Immeuble Aicha Medical",
                //   style: TextStyle(
                //     color: Theme.of(context).colorScheme.primary,
                //     fontSize: minDimension * 0.05,
                //   ),
                // ),
                Text(
                  "Avenue Mongi Slim",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.04,
                  ),
                ),
                Text(
                  "L'Aouina, Tunisie",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.04,
                  ),
                ),
                Text(
                  "Tel:   24 399 399",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.04,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "T i c k e t",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.05,
                  ),
                ),
              ],
            ),
            Text(
              "Order ID: 123",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: minDimension * 0.04,
              ),
            ),
            Text(
              "--------------------------------",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: minDimension * 0.04,
              ),
            ),
            ...cartItems.map((item) {
              double totalPrice = item['quantity'] * item['price'];
              String addons = '';
              if (item['selectedAddons'].isNotEmpty) {
                addons = item['selectedAddons'].join(', ');
              }
              return Column(
                children: [
                  Text(
                    "${item['quantity']} x ${item['food']} - \$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: minDimension * 0.04,
                    ),
                  ),
                  if (addons != '')
                    Text(
                      "Add-ons: $addons",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: minDimension * 0.04,
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
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
