import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/food_components/cart_tile.dart';
import 'package:frontend/pages/checkout_page.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return Consumer<UserProvider>(builder: ((context, user, child) {
      final userCart = user.cart;
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: minDimension * 0.08),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
              icon: const Icon(Icons.delete_outline),
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
                              itemCount: userCart.length,
                              itemBuilder: (context, index) {
                                final cartItem = userCart[index];
                                return MyCartTile(cartItem: cartItem);
                              }))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  userCart.isEmpty
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Details",
                                style: TextStyle(
                                    fontSize: minDimension * 0.05,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: TextStyle(
                                      fontSize: minDimension * 0.05,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: user
                                              .getTotalPrice()
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: minDimension * 0.05,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' DT',
                                          style: TextStyle(
                                            fontSize: minDimension * 0.05,
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
                            ],
                          ),
                        ),
                  MyButton(
                    text: "Go to checkout",
                    onTap: () async {
                      if (userCart.isNotEmpty) {
                        print(
                            'Cart is not empty, navigating to CheckoutPage'); // Debug print
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 1500),
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            content: Text(
                              'Your cart is empty!',
                              style: TextStyle(fontSize: minDimension * 0.04),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }
}
