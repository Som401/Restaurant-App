import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/pages/cart_page.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget title;
  final Widget background;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MySliverAppBar({
    super.key,
    required this.title,
    required this.background,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      expandedHeight: minDimension * 0.8,
      collapsedHeight: minDimension * 0.6,
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartPage()));
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
