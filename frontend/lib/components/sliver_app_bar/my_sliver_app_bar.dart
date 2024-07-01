import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/pages/cart_page.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget title;
  final Widget background;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MySliverAppBar(
      {super.key,
      required this.title,
      required this.background,
      required this.scaffoldKey,
      d});

  double calculateTextsHeight(BuildContext context, double minDimension) {
    final textStyle = TextStyle(
      fontSize: minDimension * 0.06,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: "order tile text", style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final height1 = textPainter.size.height;

    final totalTextsHeight = height1 * 2;
    return totalTextsHeight;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final totalTextsHeight = calculateTextsHeight(context, minDimension);
    final titleHeight = height * 0.05 + minDimension * 0.31;
    double expandedHeight = totalTextsHeight + titleHeight + minDimension * 0.2;

    return SliverAppBar(
      toolbarHeight: minDimension * 0.1,
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      expandedHeight: expandedHeight,
      collapsedHeight: titleHeight + minDimension * 0.15,
      pinned: true,
      floating: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.primary,
          size: minDimension * 0.06,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: minDimension * 0.06,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: minDimension * 0.06,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartPage()));
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: background,
        centerTitle: false,
        title: title,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}
