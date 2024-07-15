import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/food_components/payment_details.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isDelivery = false;
  bool isOrderProcessing = false;
  String processingText = "Processing";
  Timer? processingDotsTimer;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  RestaurantServices restaurantServices = RestaurantServices();

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
    processingDotsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final networkStatus = Provider.of<NetworkStatus>(context);
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
              onPressed: () =>
                  isOrderProcessing ? null : Navigator.of(context).pop(),
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
                          enabled: !isOrderProcessing,
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
                                onChanged: isOrderProcessing
                                    ? null
                                    : (value) => toggleDeliveryOption(),
                              ),
                            )
                          ],
                        ),
                        if (isDelivery) ...[
                          SizedBox(height: height * 0.01),
                          MyTextField(
                            hintText: "Enter your address here...",
                            controller: addressController,
                            enabled: !isOrderProcessing,
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
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.02,
                  ),
                  child: MyButton(
                      text: "Send Order",
                      onTap: () async {
                        if (isOrderProcessing) return;
                        try {
                          if (networkStatus == NetworkStatus.offline) {
                            QuickAlert.show(
                                context: context,
                                barrierDismissible: false,
                                type: QuickAlertType.error,
                                title: 'Order Failed',
                                text:
                                    'We were unable to process your order at this time. Please check your internet connection and try again.',
                                confirmBtnTextStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                confirmBtnColor:
                                    Theme.of(context).colorScheme.tertiary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                textColor:
                                    Theme.of(context).colorScheme.primary,
                                titleColor:
                                    Theme.of(context).colorScheme.primary,
                                onConfirmBtnTap: () {
                                  setState(() {
                                    isOrderProcessing = false;
                                    Navigator.of(context).pop();
                                  });
                                });
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.loading,
                              barrierDismissible: false,
                              title: 'Processing',
                              text: 'Your Order is being processed...',
                              confirmBtnTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              confirmBtnColor:
                                  Theme.of(context).colorScheme.tertiary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              textColor: Theme.of(context).colorScheme.primary,
                              titleColor: Theme.of(context).colorScheme.primary,
                            );
                            setState(() {
                              isOrderProcessing = true;
                            });
                            var orderFuture = restaurantServices.addOrder(
                                userProvider: user,
                                address: addressController.text,
                                notes: notesController.text);
                            await Future.wait([
                              orderFuture,
                              Future.delayed(const Duration(seconds: 2)),
                            ]);
                            Navigator.of(context).pop();
                            QuickAlert.show(
                                context: context,
                                barrierDismissible: false,
                                type: QuickAlertType.success,
                                title: 'Success',
                                text:
                                    'Your order has been successfully placed. You will receive a confirmation shortly.',
                                confirmBtnTextStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                confirmBtnColor:
                                    Theme.of(context).colorScheme.tertiary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                textColor:
                                    Theme.of(context).colorScheme.primary,
                                titleColor:
                                    Theme.of(context).colorScheme.primary,
                                onConfirmBtnTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                            Future.delayed(const Duration(seconds: 15), () {
                              if (mounted) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        } catch (e) {
                          QuickAlert.show(
                              context: context,
                              barrierDismissible: false,
                              type: QuickAlertType.error,
                              title: 'Order Failed',
                              text:
                                  'We were unable to process your order at this time. Please check your internet connection and try again.',
                              confirmBtnTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              confirmBtnColor:
                                  Theme.of(context).colorScheme.tertiary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              textColor: Theme.of(context).colorScheme.primary,
                              titleColor: Theme.of(context).colorScheme.primary,
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                              });
                          Future.delayed(const Duration(seconds: 5), () {
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      }),
                ),
              ],
            ),
          ));
    }));
  }
}
