import 'dart:math';

import 'package:flutter/material.dart';

class PaymentDetails extends StatelessWidget {
  final double subtotal;
  final bool isDeliveryFee;
  const PaymentDetails(
      {super.key, required this.subtotal, required this.isDeliveryFee});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    double deliveryFee = isDeliveryFee ? 7.0 : 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Text(
            "Payment Details",
            style: TextStyle(
                fontSize: minDimension * 0.05,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
        ]),
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Subtotal",
              style: TextStyle(
                fontSize: minDimension * 0.05,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: subtotal.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' DT',
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inverseSurface,
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
            Text(
              "Delivery Fee",
              style: TextStyle(
                fontSize: minDimension * 0.05,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: deliveryFee.toString(),
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' DT',
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inverseSurface,
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
            Text(
              "Total",
              style: TextStyle(
                fontSize: minDimension * 0.05,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: (subtotal + deliveryFee).toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' DT',
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.01),
      ],
    );
  }
}
