import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/food.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addOrder({
    required UserProvider userProvider,
    required String address,
    required String notes,
  }) async {
    if (userProvider.cart.isEmpty) {
      throw Exception("Cart is empty");
    }
    final String userId = _auth.currentUser?.uid ?? 'anonymous';

    Map<String, dynamic> order = {
      'userId': userId,
      'isDelivery': address.isNotEmpty,
      'address': address.isEmpty ? 'no_delivery' : address,
      'notes': notes,
      'items': userProvider.cart.map((cartItem) {
        return {
          'food': cartItem.food.name,
          'selectedAddons':
              cartItem.selectedAddons.map((addon) => addon.name).toList(),
          'quantity': cartItem.quantity,
          'price': cartItem.totalPrice,
        };
      }).toList(),
      'timestamp': FieldValue.serverTimestamp(),
      'state': 'pending',
    };

    try {
      await _firestore.collection('orders').add(order);
      userProvider.clearCart();
    } catch (e) {
      print("Failed to add order: $e");
      throw Exception("Failed to add order");
    }
  }

  Future<List<dynamic>> fetchUserOrders() async {
    final String userId = _auth.currentUser?.uid ?? 'anonymous';

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      List<dynamic> orders = [];
      for (var doc in querySnapshot.docs) {
        var order = doc.data();
        orders.add(order);
      }
      await Future.delayed(const Duration(seconds: 2));
      return orders;
    } catch (e) {
      print("Failed to fetch orders: $e");

      throw Exception("Failed to fetch orders: $e");
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();
      List<String> categories = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var docCategories =
            List<String>.from(data['categories'] as List<dynamic>);

        categories.addAll(docCategories);
      }
      await Future.delayed(const Duration(seconds: 2));
      return categories.toList();
    } catch (e) {
      print("Failed to fetch categories: $e");
      throw Exception("Failed to fetch categories: $e");
    }
  }

  Future<List<Food>> fetchMenu() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();
      List<Food> menu = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var docMenu =
            List<Map<String, dynamic>>.from(data['menu'] as List<dynamic>);

        var foodItems = docMenu.map((item) => Food.fromJson(item)).toList();
        menu.addAll(foodItems);
      }
      await Future.delayed(const Duration(seconds: 2));
      return menu;
    } catch (e) {
      print("Failed to fetch menu: $e");
      throw Exception("Failed to fetch menu: $e");
    }
  }

  Future<Map<String, dynamic>> fetchRestaurantDetails() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('restaurants').get();
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        var data = doc.data() as Map<String, dynamic>;
        String name = data['name'];
        String address = data['address'];
        String phoneNumber = data['phoneNumber'];
        return {
          'name': name,
          'address': address,
          'phone': phoneNumber,
        };
      } else {
        print('No restaurant details found');
        return {};
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      return {};
    }
  }
}
