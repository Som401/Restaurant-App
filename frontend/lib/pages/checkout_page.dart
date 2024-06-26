import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/food_components/payment_details.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isDelivery = false;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void toggleDeliveryOption() {
    setState(() {
      isDelivery = !isDelivery;
      if (!isDelivery) {
        addressController.clear();
      }
    });
  }

  @override
  void dispose() {
    notesController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    RestaurantServices restaurantServices = RestaurantServices();

    return Consumer<UserProvider>(builder: ((context, user, child) {
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: minDimension * 0.1,
            scrolledUnderElevation: 0,
            elevation: 0.0,
            title: Text(
              "Checkout",
              style: TextStyle(
                fontSize: minDimension * 0.05,
              ),
            ),
            centerTitle: true,
            foregroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: minDimension * 0.08),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Order Notes",
                                style: TextStyle(
                                    fontSize: minDimension * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        MyTextField(
                          hintText: "Enter your order notes here...",
                          controller: notesController,
                          multiline: 3,
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Do you want a delivery?",
                                style: TextStyle(
                                  fontSize: minDimension * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            Transform.scale(
                              scale: minDimension * 0.0025,
                              child: Checkbox(
                                value: isDelivery,
                                onChanged: (value) => toggleDeliveryOption(),
                              ),
                            )
                          ],
                        ),
                        if (isDelivery) ...[
                          SizedBox(height: height * 0.01),
                          MyTextField(
                            hintText: "Enter your address here...",
                            controller: addressController,
                          ),
                          SizedBox(height: height * 0.01),
                        ]
                      ],
                    ),
                  ),
                ),
                PaymentDetails(
                  isDeliveryFee: isDelivery,
                  subtotal: user.getTotalPrice(),
                ),
                MyButton(
                    text: "Send Order",
                    onTap: () {
                      restaurantServices.addOrder(
                          userProvider: user,
                          address: "",
                          notes: notesController.text);
                    }),
              ],
            ),
          ));
    }));
  }
}
