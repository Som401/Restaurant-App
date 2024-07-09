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
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class MenuPage extends StatefulWidget {
  final String userUid;

  const MenuPage({super.key, User? user, this.userUid = ''});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int selectedCategoryIndex = 0;
  double collapsedHeight = 0;

  bool _showBackToTopButton = false;
  bool _isLoadingCategories = true;
  bool _isLoadingMenu = true;
  bool _isLoadingUser = true;

  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.fetchUserDetails(widget.userUid).then((_) {
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
        });
      }
    });

    final restaurantProvider = Provider.of<Restaurant>(context, listen: false);
    restaurantProvider.fetchRestaurantDetails().then((_) {
      if (mounted) {
        setState(() {});
      }
    });

    restaurantProvider.fetchCategories().then((_) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
          _tabController = TabController(
              length: restaurantProvider.categories.length, vsync: this);
        });
      }
    });

    restaurantProvider.fetchMenu().then((_) {
      if (mounted) {
        setState(() {
          _isLoadingMenu = false;
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
      drawer: MyDrawer(
          isLoadingCategories: _isLoadingCategories,
          isLoadingMenu: _isLoadingMenu,
          isLoadingUser: _isLoadingUser),
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
                  top: !kIsWeb && Platform.isIOS
                      ? MediaQuery.of(context).size.shortestSide < 600
                          ? minDimension * 0.25 // iPhone
                          : minDimension * 0.12 // iPad
                      : minDimension * 0.12, //android
                ),
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
              color: Theme.of(context).colorScheme.surface,
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
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: _tabController == null
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 8,
                    itemBuilder: (context, index) => const FoodShimmerTile())
                : Consumer<Restaurant>(
                    builder: (context, restaurant, child) {
                      return TabBarView(
                        controller: _tabController,
                        children: getFoodInThisCategory(
                            restaurant.menu, context, _isLoadingMenu),
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

List<Widget> getFoodInThisCategory(
    List<Food> fullMenu, BuildContext context, bool isLoadingMenu) {
  if (isLoadingMenu) {
    return List<Widget>.generate(8, (index) => const FoodShimmerTile());
  } else {
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
}
