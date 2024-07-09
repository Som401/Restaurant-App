import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReceipt extends StatelessWidget {
  final Map<String, dynamic> order;
  final List<Map<String, dynamic>> foodItems;
  const MyReceipt({super.key, required this.order, required this.foodItems});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    final DateTime dateTime = order['timestamp'].toDate();
    String formattedDate = DateFormat('yyyy-MM-dd - HH:mm').format(dateTime);

    return SingleChildScrollView(
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
              // Text(
              //   "Avenue Mongi Slim",
              //   style: TextStyle(
              //     color: Theme.of(context).colorScheme.primary,
              //     fontSize: minDimension * 0.04,
              //   ),
              // ),
              Text(
                "L'Aouina, Tunisie",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: minDimension * 0.04,
                ),
              ),
              Text(
                "TEL  :  24 399 399",
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
          SizedBox(height: height * 0.02),
          Row(
            children: [
              Text(
                "Order Number: #123",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: minDimension * 0.04,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.008),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: width * 0.7,
            lineThickness: minDimension * 0.005,
            dashLength: minDimension * 0.02,
            dashColor: Theme.of(context).colorScheme.primary,
            dashRadius: 0.0,
            dashGapLength: minDimension * 0.02,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
          ...foodItems.map((item) {
            double totalPrice = item['quantity'] * item['price'];
            String addons = '';
            if (item['selectedAddons'].isNotEmpty) {
              addons = groupAndFormatAddons(item['selectedAddons']);
            }
            return SizedBox(
              width: width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.003),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "-${item['quantity']} ${item['food']}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        ),
                      ),
                      Text(
                        "\$${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        ),
                      ),
                    ],
                  ),
                  if (addons.isNotEmpty)
                    Padding(
                      padding:  EdgeInsets.only(left: width * 0.05),
                      child: Text(
                        "($addons)",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          SizedBox(height: height * 0.008),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: width * 0.7,
            lineThickness: minDimension * 0.005,
            dashLength: minDimension * 0.02,
            dashColor: Theme.of(context).colorScheme.primary,
            dashRadius: 0.0,
            dashGapLength: minDimension * 0.02,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
          SizedBox(
            height: height * 0.003,
          ),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: width * 0.7,
            lineThickness: minDimension * 0.005,
            dashLength: minDimension * 0.02,
            dashColor: Theme.of(context).colorScheme.primary,
            dashRadius: 0.0,
            dashGapLength: minDimension * 0.02,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
        ],
      ),
    );
  }
}

String groupAndFormatAddons(List<dynamic> addons) {
  final List<String> groupedAddons = [];
  for (var addon in addons) {
    String name = "${addon['name']}";
    print(name);
    groupedAddons.add(name);
  }
  return groupedAddons.join(', ');
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
