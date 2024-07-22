import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'food.dart';

class Restaurant extends ChangeNotifier {
  List<Food>? _menu;
  List<String>? _categories;
  String? _name;
  String? _address;
  int? _phoneNumber;
  double? _deliveryFee;
  Timestamp? _lastOrderDate;
  int? _currentOrderNumber;
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
      final restaurantDetails =
          await _restaurantServices.fetchRestaurantDetails();
      _name = restaurantDetails['name'];
      _address = restaurantDetails['address'];
      _phoneNumber = restaurantDetails['phone'];
      _deliveryFee = restaurantDetails['deliveryFee'];
      _lastOrderDate = restaurantDetails['lastOrderDate'];
      _currentOrderNumber = restaurantDetails['currentOrderNumber'];
      notifyListeners();
    }
  }

  List<Food> get menu => _menu ?? [];
  List<String> get categories => _categories ?? [];
  String get name => _name ?? '';
  String get address => _address ?? '';
  int get phoneNumber => _phoneNumber ?? 0;
  double get deliveryFee => _deliveryFee ?? 0.0;
  Timestamp get lastOrderDate => _lastOrderDate ?? Timestamp.now();
  int get currentOrderNumber => _currentOrderNumber ?? 1;

  getFoodById(item) {
    return _menu!.firstWhere((element) => element.id == item);
  }
}
