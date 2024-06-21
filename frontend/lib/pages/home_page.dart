import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/food_components/food_tile.dart';
import 'package:frontend/components/search_box/search_box.dart';
import 'package:frontend/components/food_components/food_category_list.dart';
import 'package:frontend/components/sliver_app_bar/my_sliver_app_bar.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/food.dart';
import 'package:frontend/pages/food_page.dart';
//import 'package:frontend/providers/user_provider.dart';
//import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, User? user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //final UserService _userService = UserService();
  int selectedCategoryIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          MySliverAppBar(
            scaffoldKey: _scaffoldKey,
            background: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Container(
                margin: EdgeInsets.only(
                    top: minDimension * 0.15, bottom: minDimension * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enjoy Your Meal with",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: minDimension * 0.05,
                        )),
                    Text("DelCapo",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.06,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              color: Theme.of(context).colorScheme.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SearchBox(),
                  CategoryTabBar(tabController: _tabController!),
                ],
              ),
            ),
          ),
        ],
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.02),
            child: Consumer<Restaurant>(
              builder: (context, restaurant, child) {
                return TabBarView(
                  controller: _tabController,
                  children: getFoodInThisCategory(restaurant.menu),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
  return fullMenu.where((food) => food.category == category).toList();
}

List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
  return FoodCategory.values.map((category) {
    List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: categoryMenu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final food = categoryMenu[index];
        return FoodTile(
          food: food,
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodPage(food: food),
                ),
              )
        );
      },
    );
  }).toList();
}
