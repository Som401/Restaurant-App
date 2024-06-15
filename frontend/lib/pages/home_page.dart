import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/food_category_list/food_category_icon.dart';
import 'package:frontend/components/search-box/search_box.dart';
import 'package:frontend/models/user.dart';
// import 'package:frontend/providers/user_provider.dart';
// import 'package:frontend/services/user_services.dart';
// import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, User? user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final UserService _userService = UserService();
  int selectedCategoryIndex = 0;
  final List<Map<String, String>> categories = [
    {"imagePath": "assets/images/food_logo/pizza.png", "categoryName": "Pizza"},
    {
      "imagePath": "assets/images/food_logo/burger.png",
      "categoryName": "Burger"
    },
    {"imagePath": "assets/images/food_logo/steak.png", "categoryName": "meat"},
    {
      "imagePath": "assets/images/food_logo/spaghetti.png",
      "categoryName": "Pasta"
    },
    {"imagePath": "assets/images/food_logo/salad.png", "categoryName": "Salad"},
    {
      "imagePath": "assets/images/food_logo/fried-potatoes.png",
      "categoryName": "Sides"
    },
    {
      "imagePath": "assets/images/food_logo/gelato.png",
      "categoryName": "Dessert"
    },
    {
      "imagePath": "assets/images/food_logo/drink.png",
      "categoryName": "Drinks"
    },
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<UserProvider>(context).user;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    print(selectedCategoryIndex);

    int crossAxisCount = width ~/ 87;
    crossAxisCount = max(3, min(crossAxisCount, 4));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // title: Text(
        //   '${user?.name}',
        //   style: TextStyle(
        //       color: Theme.of(context).colorScheme.primary,
        //       fontSize: minDimension * 0.05),
        // ),
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
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.05),
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
            GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: minDimension *
                  0.02, //need to be adjusted to fix spacing when screen gets bigger
              children: List.generate(categories.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: FoodCategoryIcon(
                    imagePath: categories[index]["imagePath"]!,
                    categoryName: categories[index]["categoryName"]!,
                    isSelected: index == selectedCategoryIndex,
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
