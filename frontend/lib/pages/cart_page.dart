import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/food_components/cart_tile.dart';
import 'package:frontend/components/food_components/payment_details.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final TextEditingController notesController = TextEditingController();
  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    RestaurantServices restaurantServices = RestaurantServices();

    return Consumer<UserProvider>(builder: ((context, user, child) {
      final userCart = user.cart;
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: minDimension * 0.1,
          scrolledUnderElevation: 0,
          elevation: 0.0,
          title: Text(
            "My Cart",
            style: TextStyle(
              fontSize: minDimension * 0.05,
            ),
          ),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(Icons.arrow_back, size: minDimension * 0.08),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text("clear cart",
                        style: TextStyle(
                            fontSize: minDimension * 0.04,
                            color: Theme.of(context).colorScheme.primary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("cancel",
                            style: TextStyle(
                                fontSize: minDimension * 0.04,
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          user.clearCart();
                        },
                        child: Text("yes",
                            style: TextStyle(
                                fontSize: minDimension * 0.04,
                                color: Theme.of(context).colorScheme.primary)),
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
              iconSize: minDimension * 0.05,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userCart.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Text("Cart is empty",
                                  style: TextStyle(
                                    fontSize: minDimension * 0.06,
                                  ))))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: userCart.length + 1,
                              itemBuilder: (context, index) {
                                if (index < userCart.length) {
                                  final cartItem = userCart[index];
                                  return MyCartTile(cartItem: cartItem);
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Order Notes",
                                            style: TextStyle(
                                                fontSize: minDimension * 0.05,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                        SizedBox(height: height * 0.01),
                                        MyTextField(
                                          hintText:
                                              "Enter your order notes here...",
                                          controller: notesController,
                                          multiline: 4,
                                        ),
                                        SizedBox(height: height * 0.01),
                                      ],
                                    ),
                                  );
                                }
                              }))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                userCart.isEmpty
                    ? Container()
                    : PaymentDetails(
                        isDeliveryFee: true,
                        subtotal: user.getTotalPrice(),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: minDimension * 0.05,
                      vertical: minDimension * 0.02),
                  child: MyButton(text: "Send Order", onTap: () {
                    restaurantServices.addOrder(
                        userProvider: user,
                        address: "",
                        notes: notesController.text);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }));
  }
}
