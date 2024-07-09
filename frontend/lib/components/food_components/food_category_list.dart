import 'package:flutter/material.dart';
import 'package:frontend/components/food_components/food_category_icon.dart';
import 'dart:math';
import 'package:frontend/models/restaurant.dart';
import 'package:provider/provider.dart';

class CategoryTabBar extends StatefulWidget {
  final TabController tabController;

  const CategoryTabBar({super.key, required this.tabController});

  @override
  CategoryTabBarState createState() => CategoryTabBarState();
}

class CategoryTabBarState extends State<CategoryTabBar> {
  Future<List<String>> fetchCategories() async {
    await Future.delayed(const Duration(seconds: 2));
    return Provider.of<Restaurant>(context, listen: false).categories.toList();
  }

  List<Tab> generateTabs(List<String> categories, double minDimension) {
    return categories.map((categoryName) {
      return Tab(
        height: minDimension * 0.25,
        child: FoodCategoryIcon(
          imagePath: "assets/images/food_logo/$categoryName.png",
          categoryName: categoryName[0].toUpperCase() +
              categoryName.substring(1).toLowerCase(),
          isSelected:
              widget.tabController.index == categories.indexOf(categoryName),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_setActiveTab);
    Provider.of<Restaurant>(context, listen: false).fetchCategories();
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_setActiveTab);
    super.dispose();
  }

  void _setActiveTab() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final restaurant = Provider.of<Restaurant>(context);
    final categories = restaurant.categories;

    return SizedBox(
      height: minDimension * 0.25,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        controller: widget.tabController,
        isScrollable: true,
        tabs: generateTabs(categories, minDimension),
        indicatorColor: Theme.of(context).colorScheme.inverseSurface,
        dividerHeight:0 ,
      ),
    );
  }
}
