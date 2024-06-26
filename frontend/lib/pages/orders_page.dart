import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/food_components/order_tile.dart';
import 'package:frontend/services/restaurant_services.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool active = true;

  late Future<List<dynamic>> futureOrders;
  late RestaurantServices restaurantServices; // Declare RestaurantServices

  @override
  void initState() {
    super.initState();
    restaurantServices = RestaurantServices(); // Initialize RestaurantServices
    futureOrders = restaurantServices.fetchUserOrders(); // Fetch user orders
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return FutureBuilder<List<dynamic>>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: Text("Your Orders",
                    style: TextStyle(
                      fontSize: minDimension * 0.05,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                elevation: 0,
                centerTitle: true,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: Column(children: [
                Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      active = true;
                                    });
                                  },
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: active
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      active = false;
                                    });
                                  },
                                  child: Text(
                                    'Past',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: !active
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.background,
                              )),
                            ),
                          ],
                        )))
              ]));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Text("Your Orders",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(top: 30, left: 10, right: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  active = true;
                                });
                              },
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: active
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  active = false;
                                });
                              },
                              child: Text(
                                'Past',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: !active
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.where((order) {
                                  final Timestamp timestamp =
                                      order['timestamp'] as Timestamp;

                                  final DateTime orderDate = timestamp.toDate();
                                  print(orderDate);
                                  final now = DateTime.now();
                                  if (active) {
                                    return orderDate.year == now.year &&
                                        orderDate.month == now.month &&
                                        orderDate.day == now.day;
                                  } else {
                                    return orderDate.year < now.year ||
                                        (orderDate.year == now.year &&
                                            orderDate.month < now.month) ||
                                        (orderDate.year == now.year &&
                                            orderDate.month == now.month &&
                                            orderDate.day < now.day);
                                  }
                                }).length ??
                                0,
                            itemBuilder: (context, index) {
                              final orders = snapshot.data
                                  ?.where((order) {
                                    final Timestamp timestamp =
                                        order['timestamp'] as Timestamp;

                                    final DateTime orderDate =
                                        timestamp.toDate();
                                    final now = DateTime.now();
                                    if (active) {
                                      return orderDate.year == now.year &&
                                          orderDate.month == now.month &&
                                          orderDate.day == now.day;
                                    } else {
                                      return orderDate.year < now.year ||
                                          (orderDate.year == now.year &&
                                              orderDate.month < now.month) ||
                                          (orderDate.year == now.year &&
                                              orderDate.month == now.month &&
                                              orderDate.day < now.day);
                                    }
                                  })
                                  .toList()
                                  .reversed
                                  .toList();
                              return OrderTile(order: orders?[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
