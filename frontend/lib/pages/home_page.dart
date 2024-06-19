import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/food_components/food_tile.dart';
import 'package:frontend/components/search-box/search_box.dart';
import 'package:frontend/components/food_components/food_category_list.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/food.dart';
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
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            scrolledUnderElevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.primary,
                size: minDimension * 0.06,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
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
                onPressed: () {},
              ),
            ],
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
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
            const SearchBox(),
            CategoryTabBar(tabController: _tabController!),
            Expanded( // This ensures the menu can scroll to display all elements
              child: Consumer<Restaurant>(
                builder: (context, restaurant, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: getFoodInThisCategory(restaurant.menu),
                  );
                },
              ),
            ),
          ],
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
            onTap: () {},
            // onTap: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => FoodPage(food: food),
            //       ),
            //     )
          );
        },
      );
    }).toList();
  }

