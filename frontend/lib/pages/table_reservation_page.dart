import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TableReservationPage extends StatefulWidget {
  const TableReservationPage({super.key});

  @override
  State<TableReservationPage> createState() => _TableReservationPageState();
}

class _TableReservationPageState extends State<TableReservationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return Consumer<UserProvider>(
        builder: (context, user, child) => Scaffold(
            key: _scaffoldKey,
            drawer: const MyDrawer(),
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: MyAppBar(
              title: "Table Reservation",
              scaffoldKey: _scaffoldKey,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.02),
              child: Column(
                children: [
                  Text(
                    "Hello ${user.user?.name}!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: minDimension * 0.04,
                    ),
                  ),
                  Text(
                    "Reserve a table at DelCapo",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: minDimension * 0.06,
                    ),
                  ),
                ],
              ),
            )));
  }
}
