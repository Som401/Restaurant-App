import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ReservationTile extends StatelessWidget {
  final Map<String, dynamic> reservation;
  const ReservationTile({super.key, required this.reservation});

  double calculateTextsHeight(
      BuildContext context, double minDimension, double height) {
    final textStyle = TextStyle(
      fontSize: minDimension * 0.04,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: "order tile text", style: textStyle),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height1 = textPainter.size.height;

    return height1 * 2;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final Timestamp timestamp = reservation['selectedDay'] as Timestamp;
    double calculatedHeight =
        calculateTextsHeight(context, minDimension, height);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.01),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: minDimension * 0.01),
                      width: calculatedHeight,
                      height: calculatedHeight,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: [
                          4 * (minDimension / 500),
                          4 * (minDimension / 500)
                        ],
                        radius: Radius.circular(8 * (minDimension / 500)),
                        padding: EdgeInsets.all(7 * (minDimension / 500)),
                        strokeWidth: 2 * (minDimension / 500),
                        color: reservation['state'] == 'accepted' ||
                                reservation['state'] == 'complete'
                            ? Colors.green
                            : (reservation['state'] == 'denied'
                                ? Colors.red
                                : Colors.orange),
                        child: Center(
                          child: Icon(
                            reservation['state'] == 'accepted' ||
                                    reservation['state'] == 'complete'
                                ? Icons.check_circle
                                : (reservation['state'] == 'denied'
                                    ? Icons.error
                                    : Icons.access_time),
                            size: minDimension * 0.07,
                            color: reservation['state'] == 'accepted' ||
                                    reservation['state'] == 'complete'
                                ? Colors.green
                                : (reservation['state'] == 'denied'
                                    ? Colors.red
                                    : Colors.orange),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reservation Date: ${DateFormat('yyyy-MM-dd').format(timestamp.toDate())}', // Display only the date part
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.04,
                          ),
                        ),
                        Text(
                          'Reservation Time: ${DateFormat('HH:mm').format(timestamp.toDate())}', // Display only the time part
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Nb Guests:",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: minDimension * 0.04,
                        )),
                    Text(reservation['nbGuests'].toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        )),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Occasion:",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: minDimension * 0.04,
                        )),
                    Text(reservation['occasion'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        )),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("State:",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: minDimension * 0.04,
                        )),
                    Text(reservation['state'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.04,
                        )),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.receipt_long_outlined,
                color: Theme.of(context).colorScheme.inverseSurface,
                size: minDimension * 0.04,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
