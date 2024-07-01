import 'package:flutter/material.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'food.dart';

class Restaurant extends ChangeNotifier {
  final List<Food> _menu = [
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "pizza",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "pizza",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "pizza",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "pizza",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "pizza",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "pizza",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Classic Cheeseburger",
      description:
          "Juicy Angus beef patty topped with melted cheese, fresh lettuce, ripe tomatoes, and tangy pickles.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 12.99,
      category: "burger",
      availableAddons: [
        Addon(name: "Extra Bacon", price: 2.99),
        Addon(name: "Avocado Slices", price: 1.99),
        Addon(name: "Grilled Onions", price: 0.99)
      ],
    ),
    Food(
      name: "Caesar Salad",
      description:
          "Crisp romaine lettuce tossed with Caesar dressing, topped with shaved Parmesan cheese and crunchy croutons.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 10.99,
      category: "salad",
      availableAddons: [
        Addon(name: "Grilled Chicken", price: 2.99),
        Addon(name: "Shrimp", price: 2.99)
      ],
    ),
    Food(
      name: "Garlic Parmesan Fries",
      description:
          "Golden fries tossed in garlic butter and Parmesan cheese, served piping hot.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 15.99,
      category: "sides",
      availableAddons: [
        Addon(name: "Chili Cheese", price: 2.99),
        Addon(name: "Truffle Aioli", price: 2.99)
      ],
    ),
    Food(
      name: "Chocolate Lava Cake",
      description:
          "Decadent chocolate cake with a molten chocolate center, served warm with a scoop of vanilla ice cream.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 14.99,
      category: "dessert",
      availableAddons: [
        Addon(name: "Extra Ice Cream Scoop", price: 2.99),
        Addon(name: "Caramel Drizzle", price: 2.99)
      ],
    ),
    Food(
      name: "Iced Caramel Macchiato",
      description:
          "Rich espresso combined with creamy milk and swirls of caramel, poured over ice.",
      imagePath: "assets/images/food_menu/Margherita-Pizza.jpg",
      price: 9.99,
      category: "drinks",
      availableAddons: [
        Addon(name: "Extra Shot", price: 2.99),
        Addon(name: "Whipped Cream", price: 2.99)
      ],
    ),
  ];
  List<String>? _categories;
  final RestaurantServices _restaurantServices = RestaurantServices();

  Future<void> fetchCategories() async {
    if (_categories == null) {
      _categories = await _restaurantServices.fetchCategories();
      notifyListeners();
    }
  }

  List<Food> get menu => _menu;
  List<String> get categories => _categories ?? [];
}
