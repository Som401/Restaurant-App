// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:frontend/components/food_components/food_category_icon.dart';
// import 'package:frontend/models/food.dart';

// class CategoryTabBar extends StatefulWidget {
//   final TabController tabController;

//   const CategoryTabBar({super.key, required this.tabController});

//   @override
//   CategoryTabBarState createState() => CategoryTabBarState();
// }

// class CategoryTabBarState extends State<CategoryTabBar> {
//   List<String> generateCategoryNames() {
//     return FoodCategory.values.map((category) {
//       return category.toString().split('.').last;
//     }).toList();
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.tabController.addListener(_setActiveTab);
//   }

//   @override
//   void dispose() {
//     widget.tabController.removeListener(_setActiveTab);
//     super.dispose();
//   }

//   void _setActiveTab() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final minDimension = min(width, height);
//     final categories = generateCategoryNames();

//     return SizedBox(
//       height: minDimension * 0.25,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(right: minDimension * 0.04),
//             child: GestureDetector(
//               onTap: () {
//                 widget.tabController.animateTo(index);
//               },
//               child: FoodCategoryIcon(
//                 imagePath: "assets/images/food_logo/${categories[index]}.png",
//                 categoryName: categories[index][0].toString().toUpperCase() +
//                     categories[index].substring(1).toLowerCase(),
//                 isSelected: widget.tabController.index == index,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/components/food_components/food_category_icon.dart';
import 'dart:math';
import 'package:frontend/models/food.dart';

class CategoryTabBar extends StatefulWidget {
  final TabController tabController;

  const CategoryTabBar({super.key, required this.tabController});

  @override
  CategoryTabBarState createState() => CategoryTabBarState();
}

class CategoryTabBarState extends State<CategoryTabBar> {
  List<String> generateCategoryNames() {
    return FoodCategory.values.map((category) {
      return category.toString().split('.').last;
    }).toList();
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
    final categories = generateCategoryNames();

    return SizedBox(
      height: minDimension * 0.25,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        controller: widget.tabController,
        isScrollable: true,
        tabs: generateTabs(categories, minDimension),
        indicatorColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}