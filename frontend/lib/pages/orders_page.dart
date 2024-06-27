import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/food_components/order_tile.dart';
import 'package:frontend/components/food_components/shimmer_item.dart'; // Import ShimmerItem
import 'package:frontend/services/restaurant_services.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool active = true;

  late Future<List<dynamic>> futureOrders;
  late RestaurantServices restaurantServices;

  @override
  void initState() {
    super.initState();
    restaurantServices = RestaurantServices();
    futureOrders = restaurantServices.fetchUserOrders();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              key: _scaffoldKey,
              drawer: const MyDrawer(),
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: MyAppBar(
                title: "Your Orders",
                scaffoldKey: _scaffoldKey,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  active = true;
                                });
                              },
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: minDimension * 0.04,
                                    fontWeight: active
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  active = false;
                                });
                              },
                              child: Text(
                                'Past',
                                style: TextStyle(
                                    fontSize: minDimension * 0.04,
                                    fontWeight: !active
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) =>
                                const ShimmerItem(),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ));
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Scaffold(
            key: _scaffoldKey,
            drawer: const MyDrawer(),
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: MyAppBar(
              title: "Your Orders",
              scaffoldKey: _scaffoldKey,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.02),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  active = true;
                                });
                              },
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: minDimension * 0.04,
                                    fontWeight: active
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  active = false;
                                });
                              },
                              child: Text(
                                'Past',
                                style: TextStyle(
                                    fontSize: minDimension * 0.04,
                                    fontWeight: !active
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.where((order) {
                                  final Timestamp timestamp =
                                      order['timestamp'] as Timestamp;

                                  final DateTime orderDate = timestamp.toDate();
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
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
