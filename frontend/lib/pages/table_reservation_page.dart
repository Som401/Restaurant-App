import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/reservation_components/reservation_shimmer_tile.dart';
import 'package:frontend/components/reservation_components/reservation_tile.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/pages/table_reservation_info_page.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'package:provider/provider.dart';

class TableReservationPage extends StatefulWidget {
  const TableReservationPage({super.key});

  @override
  State<TableReservationPage> createState() => _TableReservationPageState();
}

class _TableReservationPageState extends State<TableReservationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<dynamic>> futureReservations;
  late RestaurantServices restaurantServices;
  List<dynamic> reservations = [];

  @override
  void initState() {
    super.initState();
    restaurantServices = RestaurantServices();
    futureReservations = fetchReservations();
  }

  Future<List<dynamic>> fetchReservations() async {
    final fetchedReservations =
        await restaurantServices.fetchUserReservations();
    setState(() {
      reservations = fetchedReservations;
    });
    return fetchedReservations;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: "Table Reservation",
        scaffoldKey: _scaffoldKey,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              right: width * 0.05, left: width * 0.05, top: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              greetingText(user, minDimension, context),
              restaurantNameText(minDimension, context),
              Expanded(
                child: reservationList(futureReservations, minDimension),
              ),
              MyButton(
                  text: 'Reserve a table',
                  onTap: () async {
                    final reservationData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TableReservationInfoPage(),
                      ),
                    );
                    if (reservationData != null) {
                      setState(() {
                        reservations.add(reservationData);
                        print(reservationData);
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget greetingText(User? user, double minDimension, BuildContext context) {
    return Text(
      'Hello, ${user?.name}!',
      style: TextStyle(
        fontSize: minDimension * 0.04,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget restaurantNameText(double minDimension, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reserve a table at',
          style: TextStyle(
            fontSize: minDimension * 0.07,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          'DelCapo',
          style: TextStyle(
            fontSize: minDimension * 0.07,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget reservationList(
      Future<List<dynamic>> futureReservations, double minDimension) {
    return FutureBuilder<List<dynamic>>(
        future: futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 6,
                itemBuilder: (context, index) =>
                    const ReservationShimmerTile());
          } else if (snapshot.hasData || reservations.isNotEmpty) {
            print(reservations);
            if (reservations.isEmpty) {
              return Center(
                child: Text(
                  'No reservations found.',
                  style: TextStyle(fontSize: minDimension * 0.05),
                ),
              );
            }
            reservations
                .sort((a, b) => b['selectedDay'].compareTo(a['selectedDay']));
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return ReservationTile(reservation: reservation);
                });
          } else {
            return const Center(child: Text('No reservations found.'));
          }
        });
  }
}
