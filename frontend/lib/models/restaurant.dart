import 'package:flutter/material.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'food.dart';

class Restaurant extends ChangeNotifier {
  List<Food>? _menu;
  List<String>? _categories;
  late String _name;
  late String _address;
  late int  _phone;
  final RestaurantServices _restaurantServices = RestaurantServices();

  Future<void> fetchCategories() async {
    if (_categories == null) {
      _categories = await _restaurantServices.fetchCategories();
      notifyListeners();
    }
  }

  Future<void> fetchMenu() async {
    if (_menu == null) {
      _menu = await _restaurantServices.fetchMenu();
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetails() async {
    if (_name == null) {
      final restaurantDetails = await _restaurantServices.fetchRestaurantDetails();
      _name = restaurantDetails['name'];
      _address = restaurantDetails['address'];
      _phone = restaurantDetails['phone'];
      notifyListeners();
    }
  }

  List<Food> get menu => _menu ?? [];
  List<String> get categories => _categories ?? [];
  String get name => _name;
  String get address => _address;
  int get phone => _phone;
}
