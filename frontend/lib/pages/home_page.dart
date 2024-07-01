import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/food_components/food_category_shimmer.dart';
import 'package:frontend/components/food_components/food_shimmer_tile.dart';
import 'package:frontend/components/food_components/food_tile.dart';
import 'package:frontend/components/search_box/search_box.dart';
import 'package:frontend/components/food_components/food_category_list.dart';
import 'package:frontend/components/sliver_app_bar/my_sliver_app_bar.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/food.dart';
import 'package:frontend/pages/food_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, User? user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedCategoryIndex = 0;
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  double collapsedHeight = 0;
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Restaurant>(context, listen: false).fetchCategories().then((_) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
          _tabController = TabController(
              length: Provider.of<Restaurant>(context, listen: false)
                  .categories
                  .length,
              vsync: this);
        });
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.offset >= collapsedHeight) {
        setState(() => _showBackToTopButton = true);
      } else {
        setState(() => _showBackToTopButton = false);
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    collapsedHeight =
        height * 0.02 * 2 + minDimension * 0.06 + minDimension * 0.25;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: NestedScrollView(
        controller: _scrollController,
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
                  SizedBox(
                    height: height * 0.01,
                  ),
                  _isLoadingCategories
                      ? const FoodCategoryShimmer()
                      : CategoryTabBar(tabController: _tabController!),
                ],
              ),
            ),
          ),
        ],
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: _tabController == null
                ? ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) => const FoodShimmerTile())
                : Consumer<Restaurant>(
                    builder: (context, restaurant, child) {
                      return TabBarView(
                        controller: _tabController,
                        children:
                            getFoodInThisCategory(restaurant.menu, context),
                      );
                    },
                  ),
          ),
        ),
      ),
      floatingActionButton: _showBackToTopButton
          ? SizedBox(
              width: minDimension * 0.12,
              height: minDimension * 0.12,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                child: Icon(
                  Icons.arrow_upward,
                  size: minDimension * 0.08,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}

List<Food> _filterMenuByCategory(String category, List<Food> fullMenu) {
  return fullMenu.where((food) => food.category == category).toList();
}

List<Widget> getFoodInThisCategory(List<Food> fullMenu, BuildContext context) {
  final restaurant = Provider.of<Restaurant>(context, listen: false);
  return restaurant.categories.map((category) {
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
                ));
      },
    );
  }).toList();
}
